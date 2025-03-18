# How to perform MMPBSA

## Introduction

This is a tutorial about how to perform MM/PBSA analysis.  
I hope you can enjoy it.

<!-- Currently, there are generally two software can be used to perform MM/PBSA analysis, `MMPBSA.py` and `gmx_MMPBSA` (the `mmpbsa.pl` is too old and difficult to use).
The former uses amber format topology and the later uses gromacs format topology
In this tutorial, I will introduce the workflow of both. -->

In this tutorial, we will introduce how to use `gmx_MMPBSA`.


## Install

We use `anaconda` to install the `gmx_MMPBSA`.
According to the [website](https://valdes-tresanco-ms.github.io/gmx_MMPBSA/dev/installation/).
We can download the [env.yml](https://valdes-tresanco-ms.github.io/gmx_MMPBSA/1.6.4/env.yml) to config the environment.
The content in env.yml is as follows:
```yml
name: gmxMMPBSA
channels:
  - defaults
  - conda-forge
dependencies:
  - python=3.11.8
  - pip
  - numpy=1.26.4
  - ambertools=23.6
  - mpi4py=4.0.1
  - matplotlib=3.7.3
  - scipy=1.14.1
  - parmed=4.2.2


  - pandas=1.5.3
  - seaborn=0.11.2
  - tqdm

  - git
  - gromacs<=2024.3
  - pip:
      - pyqt6==6.7.1
```

Then, we can use this command to config the environment:

```
conda env create --file env.yml
```

Finally, we can use this command to install `gmx_MMPBSA`:

```
python -m pip install gmx_MMPBSA
```

> This command will create a `gmxMMPBSA` environment in `anaconda`. If you want to change the name of the environment, you can modify the `name` in `env.yml`. This command will also install `ambertools` in this environment, so we don't need to install the `ambertools` for `MMPBSA.py` again. This command can work well on `cell` and `tsubame`.

Then, we can activate the environment:

```bash
conda activate gmx_MMPBSA
```

## run gmx_MMPBSA

To use the `gmx_MMPBSA` to perform MM/PBSA analysis, we should prepare gromacs format trajectory (`.xtc`), topology (`.top`) and index file (`.ndx`). If you use psf_dcd files, you can refer to this [page](https://valdes-tresanco-ms.github.io/gmx_MMPBSA/1.6.4/examples/psf_dcd/protein_protein/) to know how to convert those format to gromacs format.

### convert psf_dcd files

#### The topology files

> All those precesses are in `charmm` directory. You need to prepare your `step3_input.psf` and `step3_input.crd`.

We are going to use `ParmEd` to convert the *.psf file into a GROMACS topology file. To do so, use the ParmEd script that is already included in the `charmm` folder.

```bash
python script.py
```

Take your time to analyze step by step the process of converting .psf/.crd files into a GROMACS topology with ParmEd.

```python
import parmed as pmd

psf = pmd.load_file('step3_input.psf')

psf.coordinates = pmd.load_file('step3_input.crd').coordinates

psf.strip(":POT, CLA, TIP3, LIT, SOD, RUB, CES, BAR")

params = pmd.charmm.CharmmParameterSet(
                        'toppar/par_all36m_prot.prm',
                        'toppar/par_all36_na.prm',
                        'toppar/par_all36_carb.prm',
                        'toppar/par_all36_lipid.prm',
                        'toppar/par_all36_cgenff.prm',
                        'toppar/par_interface.prm',
                        'toppar/toppar_water_ions.str')

psf.load_parameters(params)

psf.save('gromacs.top')
```

#### The MD Structure+mass(db) and the trajectory files

We are going to use cpptraj program from Amber to process the *.psf and *.dcd files. To reduce the size, we have strip water and ions, so we need to use processed topology without water and ions:

```
Press enter after every command line

    cpptraj -p gromacs.top
    >trajin traj.dcd
    >strip :POT,CLA,TIP3,SOD
    >trajout gromacs.pdb onlyframes 1
    >trajout traj.xtc
    >run
    >exit
```




#### The index file

The last file we need to generate is the index file containing the groups with the receptor and ligand atoms. To do so, just use make_ndx from GROMACS and the MD Structure+mass(db) that was generated previously.

For the IGF1R/INSR system, the residue 1-861 is IGF1R and the residue 862-1732 is INSR.

```
Press enter after every command line

    gmx make_ndx -f gromacs.pdb -o index.ndx
    >r 1-861
    >r 862-1732
    > name 10 IGF1R
    > name 11 INSR
    >q
```

### run the MM/PBSA

Then we can run the analysis by this command:

```
gmx_MMPBSA -O -i mmpbsa.in -cs gromacs.pdb -ct traj.xtc -ci index.ndx -cg 10 11 -cp gromacs.top -o FINAL_RESULTS_MMPBSA.dat -eo FINAL_RESULTS_MMPBSA.csv
```

To run use `mpi`, we can run like this:

```
mpirun -np 10 gmx_MMPBSA -O -i mmpbsa.in -cs gromacs.pdb -ct traj.xtc -ci index.ndx -cg 10 11 -cp gromacs.top -o FINAL_RESULTS_MMPBSA.dat -eo FINAL_RESULTS_MMPBSA.csv
```

> Because I only provide a trajectory with 10 frames, the `-np` must smaller than the frame number.

To submit a job to the cell:

```bash
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
```




