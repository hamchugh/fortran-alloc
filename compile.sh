#!/bin/bash

# Use Spack for compiler access
. /home/hamchugh/spack/share/spack/setup-env.sh

# Clean up old data
rm -rf ./*.exe
rm -rf ./perf.data*

# Unlimited stack size
ulimit -s unlimited

# Make flang available
spack load aocc@4.1.0 target=x86_64
export FC=flang
export FFLAGS="-O3 -Mstack_arrays -g"
export PROGRAM=flang4.1.0_toy.exe
make clean && make
numactl --physcpubind=0 perf record -o perf.data.flang4.1.0 ./flang4.1.0_toy.exe
numactl --physcpubind=0 time ./flang4.1.0_toy.exe

# Remove previously used compilers
spack unload --all
# Make intel compiler available
spack load intel-oneapi-compilers
export FC=ifort
export FFLAGS="-O3 -g"
export PROGRAM=ifort2021.10.0_toy.exe
make clean && make
numactl --physcpubind=0 perf record -o perf.data.ifort2021.10.0 ./ifort2021.10.0_toy.exe
numactl --physcpubind=0 time ./ifort2021.10.0_toy.exe

# Remove previously used compilers
spack unload --all
export FC=gfortran
export FFLAGS="-O3 -g"
export PROGRAM=gfortran11.3.0_toy.exe
make clean && make
numactl --physcpubind=0 perf record -o perf.data.gfortran11.3.0 ./gfortran11.3.0_toy.exe
numactl --physcpubind=0 time ./gfortran11.3.0_toy.exe
