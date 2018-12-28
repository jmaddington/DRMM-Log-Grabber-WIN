# Overview #
Component to grab files from an input variable, copy them, zip them and put the zip in a directory specified by another variable.

# Usage #
The variables below make use mostly self explanatory. The zipfile will automatically be named HOSTNAME-datestamp.zip, such as JM_Laptop-20181219211452.zip

## Variables
* log_grabber_files: string of files to copy, seperated by semicolons. YOU HAVE TO USE POWERSHELL ENVIRONMENTAL VARIABLES if you are using environmental variables. i.e., $env:ProgramData instead of %ProgramData%
* log_grabber_datto_rmm: Tired of grabbing all those pesky log files dRMM support is asking for? What, it's almsot like they want to help! Set this to "true" and this component will automatically grab all the log files, including the entire CentraStage dierctory.
* log_grabber_output_dir: The output where you want the zipfile copied to.

You can _remove_ any of these variables and set them at either the site or the account level if you have other common files you need to get, or if you want the zip file put in the same place everytime.

Please note that you can put in non-existant files and this component will happily skip over them. The purpose of this is to allow easy grabs of mass log files, and not have to change the script/input variables everytime. (I.e., 32 vs 64 bit, Win7 vs Win10)

# Building #
Download or fork, cd into build and run repackage.bat and upload aem-component.cpt to dRMM. You can also download the aem-component.cpt straight from this repository and install in your dRMM instance.

# Bonus #
You'll find a basic toolchain for creating and editing dRMM compononts in the bin, build and initialize directories. Feel free to use it.