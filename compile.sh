#!/bin/bash

# Use Spack for compiler access
. /work/hamchugh/spack/share/spack/setup-env.sh

for arch in znver2 znver3 znver4
do

mkdir -p $arch
cd $arch
cp ../Makefile .
cp ../*.F90 .

# Clean up old data
rm -rf ./*.exe
rm -rf ./perf.data*

# Unlimited stack size
ulimit -s unlimited

# Make flang available
spack load aocc@4.1.0 target=x86_64
export FC=flang
export FFLAGS="-O3 -Mstack_arrays -g -march=$arch -mtune=$arch"
export LDFLAGS="-lm -lamdalloc"
export PROGRAM=flang4.1.0_toy.exe
make clean && make
numactl --physcpubind=0 perf stat ./flang4.1.0_toy.exe
numactl --physcpubind=0 perf record -o perf.data.flang4.1.0 ./flang4.1.0_toy.exe
echo "TIMING FOR ZENSS"
export MALLOC_CONF=stats_print:true
numactl --physcpubind=0 time ./flang4.1.0_toy.exe

# Remove previously used compilers
spack unload --all
# Make intel compiler available
spack load intel-oneapi-compilers target=x86_64
export FC=ifort

# Equivalent for Itel flags
if [ "$arch" == "znver2" ] || [ "$arch" == "znver3" ]; then
    arch_flags="core-avx2"
elif [ "$arch" == "znver4" ]; then
    arch_flags="skylake-avx512"
else
    echo "Unsupported architecture: $arch"
    exit 1
fi

export FFLAGS="-O3 -g -march=$arch_flags -mtune=$arch_flags"
export LDFLAGS="-lm"
export PROGRAM=ifort2021.10.0_toy.exe
make clean && make
numactl --physcpubind=0 perf stat ./ifort2021.10.0_toy.exe
numactl --physcpubind=0 perf record -o perf.data.ifort2021.10.0 ./ifort2021.10.0_toy.exe
echo "TIMING FOR INTEL"
numactl --physcpubind=0 time ./ifort2021.10.0_toy.exe

# Remove previously used compilers
spack unload --all
spack load gcc@13.1.0 target=x86_64
export FC=gfortran
export FFLAGS="-O3 -g -march=$arch -mtune=$arch"
export LDFLAGS="-lm"
export PROGRAM=gfortran13.1.0_toy.exe
make clean && make
numactl --physcpubind=0 perf stat ./gfortran13.1.0_toy.exe
numactl --physcpubind=0 perf record -o perf.data.gfortran13.1.0 ./gfortran13.1.0_toy.exe
echo "TIMING FOR GNU"
numactl --physcpubind=0 time ./gfortran13.1.0_toy.exe

cd ..

done
