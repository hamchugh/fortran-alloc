#!/bin/bash

# Use Spack for compiler access
. /work/hamchugh/spack/share/spack/setup-env.sh

# Clean up old data
rm -rf ./*.exe
rm -rf ./perf.data*

# Unlimited stack size
ulimit -s unlimited

# Make flang available
spack load aocc@4.1.0 target=x86_64
export FC=flang
export FFLAGS="-O3 -Mstack_arrays -g -march=native -mtune=native"
export LDFLAGS="-lm -lamdalloc"
export MALLOC_CONF=stats_print:true
export PROGRAM=flang4.1.0_toy.exe
make clean && make
numactl --physcpubind=0 perf stat ./flang4.1.0_toy.exe
numactl --physcpubind=0 perf record -o perf.data.flang4.1.0 ./flang4.1.0_toy.exe
numactl --physcpubind=0 time ./flang4.1.0_toy.exe

# Remove previously used compilers
spack unload --all
# Make intel compiler available
spack load intel-oneapi-compilers target=x86_64
export FC=ifort
export FFLAGS="-O3 -g -march=native -mtune=native"
export LDFLAGS="-lm"
export PROGRAM=ifort2021.10.0_toy.exe
make clean && make
numactl --physcpubind=0 perf stat ./ifort2021.10.0_toy.exe
numactl --physcpubind=0 perf record -o perf.data.ifort2021.10.0 ./ifort2021.10.0_toy.exe
numactl --physcpubind=0 time ./ifort2021.10.0_toy.exe

# Remove previously used compilers
spack unload --all
spack load gcc@13.1.0 target=x86_64
export FC=gfortran
export FFLAGS="-O3 -g -march=native -mtune=native"
export LDFLAGS="-lm"
export PROGRAM=gfortran13.1.0_toy.exe
make clean && make
numactl --physcpubind=0 perf stat ./gfortran13.1.0_toy.exe
numactl --physcpubind=0 perf record -o perf.data.gfortran13.1.0 ./gfortran13.1.0_toy.exe
numactl --physcpubind=0 time ./gfortran13.1.0_toy.exe
