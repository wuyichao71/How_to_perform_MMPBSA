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
