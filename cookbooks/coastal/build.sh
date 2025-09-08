#!/bin/bash

echo "Cloning relevant repos"
git clone https://github.com/NGWPC/ngen-forcing.git ./extern/ngen-forcing
git clone https://github.com/NGWPC/t-route.git ./extern/t-route
git clone https://github.com/NGWPC/schism.git --branch PhilMiller-bmi-interface --recurse-submodules ./extern/schism

echo "Building t-route"
echo "Assuming:"
echo "- a linux-distro for installation of dependencies"
echo "- your python env is activated"
sudo yum install -y epel-release
sudo yum install -y netcdf netcdf-fortran netcdf-fortran-devel netcdf-openmpi
sudo yum install -y git cmake python3.11-devel gcc gcc-gfortran make
sudo yum install -y openmpi openmpi-devel
sudo yum install -y gcc-gfortran libgfortran libgfortran-static

cd extern/t-route
uv pip install -e .
./compiler_uv.sh
deactivate

echo "Building SCHISM"
cd ../schism
mkdir build
cd build
module load mpi/openmpi-x86_64
cmake -C ../cmake/SCHISM.local.build -C ../cmake/SCHISM.local.ubuntu ../src/
make -j8 pschism
ln -s cp bin/pschism_wcoss2_NO_PARMETIS_TVD-VL ../../schism_run_dir

echo "Building Datum Sync"
cd ../../datum-sync
uv pip install -e .

