Information about the Fuel Use Code:

This set of files assumes that the user has already obtained the 2018 Industrial Energy Data Book (IEDB) from:
https://github.com/NREL/Industry-energy-data-book

Updates were made to the following files in the IEDB:
Folder 'code':
* run_GHGRP_IEDB.py: minor
* calc_GHGRP_energy_IEDB.py: updates for python versioning, removal of filters on NAICS codes/electricity generation
* find_fips.py: minor
Folder 'calculation_data/ghgrp_data':
* fac_table_2010.csv

New files:
* get_GHGRP_data.jl: an updated version of Get_GHGRP_data_IEDB.py that retrieves GHGRP data from EnviroFacts. Changes to EnviroFacts formatting over the years requires constant updating of the data retrievals. A change was also made to the way T3 gas, liquid, and solid files are formatted.

Folder GHGRP_NREL: 
* NREL_GHGRP_data_processing.jl: checks EPA's FUEL_DATA worksheet; attempts to make a match between output of IEDB code. If no match is made, use CH4 (usually) default emissions factors to estimate fuel use.

Folder GHGRP_NREL/Data:
* Contains manually downloaded EPA data files used by this script
