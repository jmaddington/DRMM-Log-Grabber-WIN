#do something

$files_string = ""

if (!($env:test -eq $true)) {

    #Check for variables

    if (!($null -eq $env:log_grabber_files)){
        $files_string += $env:log_grabber_files + ";"
    }

    #Based on http://help.aem.autotask.net/en/Content/5AGENT/LogFile.htm?Highlight=log%20files
    #...and actual tech support tickets
    if ($env:log_grabber_datto_rmm -eq $true) {
        $files_string += "$env:ProgramFiles\CentraStage\log.txt;${env:ProgramFiles(x86)}\CentraStage\log.txt;$env:ProgramFiles\CentraStage\archives\*;${env:ProgramFiles(x86)}\CentraStage\archives\*;"
        $files_string += "$env:ProgramData\CentraStage\AEMAgent\DataLog\;$env:ProgramData\CentraStage\AEMAgent\Monitors.json;$env:ProgramData\CentraStage\Monitoring\*;$env:ProgramData\CentraStage\EndpointSecurity\policy.xml;$env:ProgramData\CentraStage\EndpointSecurity\aes\*.log"
    }

    if ($null -eq $env:log_grabber_output_dir) {
        Write-Host "Output directory not specified, will output to local directory"
        Write-Host "This is not best practice"
        $log_grabber_output_dir = ".\"
    } else {
        $log_grabber_output_dir = $env:log_grabber_output_dir
    }

} else {
    #We're in testing mode
}

#Dump all the environmental variables to stdout, usually only for debugging
if ($env:dump_env_vars -eq $true) {
    Write-Host (Get-ChildItem variable:$env)
}

$files = $files_string.split(";");

$date = Get-Date
$dir = -join($env:computername,'-', $date.Year, $date.Month, $date.Day, $date.Hour, $date.Minute, $date.Second)
$zipfile = -join($env:computername,'-', $date.Year, $date.Month, $date.Day, $date.Hour, $date.Minute, $date.Second, ".zip")

#New-Item -ItemType Directory -Force -Path .\$dir
Write-Host $files_string

#Copy the files
foreach ($file in $files) {
    if (!($null -eq $file)) {
        if (Test-Path -Path "$file") {
            #Copy-Item -Recurse -Force "$file" -Destination .\$dir\
            #Write-Host "Copying $file"
            .\bin\7zip\7z.exe a $log_grabber_output_dir\$zipfile -tzip -spf $file
        }
    } else {
        Write-Host "$file wasn't found, continuing without it"
    }
}