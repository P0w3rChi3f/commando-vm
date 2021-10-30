$apps = import-csv .\packages.csv

foreach ($app in $apps) {

    $TrimmedApp = [System.IO.Path]::GetFileNameWithoutExtension((($app)."PackageName"))
    if ((Test-Path .\Downloads\$trimmedApp)-or (Test-Path ".\$TrimmedApp.*.nupkg")) {
        Write-host "$TrimmedApp already downloaded, coninuing on"
    }
    Else {Write-host "Downloading $TrimmedApp now"}

}    