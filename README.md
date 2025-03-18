# How to perform MMPBSA

## Introduction

This is a tutorial about how to perform MM/PBSA analysis.  
I hope you can enjoy it.

Currently, there are generally two software can be used to perform MM/PBSA analysis, `MMPBSA.py` and `gmx_MMPBSA` (the `mmpbsa.pl` is too old and difficult to use).
The former uses amber format topology and the later uses gromacs format topology
In this tutorial, I will introduce the workflow of both.


## Install

We use `anaconda` to install the `gmx_MMPBSA`.
According to the [website](https://valdes-tresanco-ms.github.io/gmx_MMPBSA/dev/installation/).
We can download the [env.yml](https://valdes-tresanco-ms.github.io/gmx_MMPBSA/1.6.4/env.yml).
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

Then, we can use this command to install it

```bash
conda env create --file env.yml
```

> This command will create a `gmxMMPBSA` environment in `anaconda`. If you want to change the name of the environment, you can modify the `name` in `env.yml`. This command will also install `ambertools` in this environment, so we don't need to install the `ambertools` for `MMPBSA.py` again. This command can work well on `cell` and `tsubame`.

Then, we can activate the environment:

```bash
conda activate gmx_MMPBSA
```

## run gmx_MMPBSA

To use the `gmx_MMPBSA` to perform MM/PBSA analysis, we should prepare gromacs format trajectory (`.xtc`), topology (`.top`) and index file (`.ndx`). If you use psf_dcd files, you can refer to this [page](https://valdes-tresanco-ms.github.io/gmx_MMPBSA/1.6.4/examples/psf_dcd/protein_protein/) to know how to convert those format to gromacs format.

### convert psf_dcd files

#### The MD Structure+mass(db) and the trajectory files

#### The topology files

### The index file

## run MMPBSA.py



