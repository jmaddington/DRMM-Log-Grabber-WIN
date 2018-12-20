#do something

$files_string = ""

if (!($env:test -eq $true)) {

    #Check for variables

    if (!($null -eq $env:log_grabber_files)){
        $files_string += $env:log_grabber_files + ";"
    }

    if ($env:log_grabber_datto_rmm -eq $true) {
        $files_string += "$env:ProgramFiles\CentraStage\;$env:ProgramFiles (x86)\CentraStage\;$env:ProgramData\CentraStage\AEMAgent\DataLog\"
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

$files = $files_string.split(";");

$date = Get-Date
$dir = -join($env:computername,'-', $date.Year, $date.Month, $date.Day, $date.Hour, $date.Minute, $date.Second)
$zipfile = -join($env:computername,'-', $date.Year, $date.Month, $date.Day, $date.Hour, $date.Minute, $date.Second, ".zip")

New-Item -ItemType Directory -Force -Path .\$dir

#Copy the files
foreach ($file in $files) {
    if (Test-Path -Path "$file") {
        Copy-Item -Recurse -Force "$file" -Destination .\$dir\
        Write-Host "Copying $file"
    } else {
        Write-Host "$file wasn't found, continuing without it"
    }
}

.\bin\7zip\7z.exe a  $log_grabber_output_dir\$zipfile -tzip  .\$dir\*