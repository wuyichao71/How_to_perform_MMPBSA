#!/usr/bin/env bash
#$ -S /bin/bash
#$ -cwd
#$ -l mem_free=100G
#$ -pe mpi 10
#$ -q all.q@helix.local
#$ -N gmx_mmpbsa
#$ -e stdout_gmx_mmpbsa
#$ -o stdout_gmx_mmpbsa

source ~/Documents/load_conda.sh
conda activate gmxMMPBSA_test

export OPENBLAS_NUM_THREADS=1

date
mpirun -np 10 gmx_MMPBSA -O -i mmpbsa.in -cs gromacs.pdb -ct traj.xtc -ci index.ndx -cg 10 11 -cp gromacs.top -o FINAL_RESULTS_MMPBSA.dat -eo FINAL_RESULTS_MMPBSA.csv
date
