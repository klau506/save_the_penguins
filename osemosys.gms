$title OSeMOSYS

* 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* 2017.11.08 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* 2020.04.15 scenario execute unload by Giacomo Marangoni
* 2022.03.28 changes to dec and equ files
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* utopia_data.gms
* osemosys_equ.gms
*
* To run this GAMS version of OSeMOSYS on your PC:
* 1. YOU MUST HAVE GAMS VERSION 22.7 OR HIGHER INSTALLED.
* This is because OSeMOSYS has some parameter, variable and equation names
* that exceed 31 characters in length, and GAMS versions prior to 22.7 have
* a limit of 31 characters on the length of such names.
* 2. Ensure that your PATH contains the GAMS Home Folder.
* 3. Place all 4 of the above files in a convenient folder,
* open a Command Prompt window in this folder, and enter:
* gams osemosys.gms
* 4. You should find that you get an optimal value of 29446.861.
* 5. Some results are created in file SelResults.CSV that you can view in Excel.
*

* Scenario name
$setglobal scenario base_5
*$setglobal scenario base_10
*$setglobal scenario base_15
*$setglobal scenario indep_5
*$setglobal scenario indep_10
*$setglobal scenario indep_15

$offlisting

* declarations for sets, parameters, variables
$include osemosys_dec.gms

* specify Italy Model data
$include italy_data_%scenario%.gms

* define model equations
$include osemosys_equ.gms

$onlisting

* solve the model
model osemosys /all/;

option limrow=0, limcol=0, solprint=on;
option mip = copt;
solve osemosys minimizing z using mip;

* create results in file SelResults.CSV
* $include osemosys_res.gms

execute_unload 'results_%scenario%.gdx';
