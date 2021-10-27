$apps = Import-Csv ./packages.csv
$myDownloadList = @()

New-Item -ItemType Directory -name Downloads -path . -Force
Set-Location .\Downloads

foreach ($app in $apps) {

    $TrimmedApp = [System.IO.Path]::GetFileNameWithoutExtension((($app)."PackageName"))
    if ($app.url -like "https://github.com*") {
        Write-host "$trimmedApp is on GitHub "
        $AppObject = [PSCustomObject]@{
            AppName = $TrimmedApp
            PackageName = "$trimmedApp.git"
            Description = $app.Description
            Category = $app.Category
            AppUrl = $app.URL
            DownloadURL = "$($app.url).git"
            HowToInstall = "git clone $($app.url).git"
             } # End Custom Object
        
        $myDownloadList += $AppObject
        #Test to see if it exists
        git clone $AppObject.DownloadURL
    }
    Else {
        write-host "Searching on Chocolatey for $trimmedApp"

        $APPhref = (Invoke-WebRequest  -Uri https://community.chocolatey.org/packages?q=$TrimmedApp).links.href | Where-Object {$_ -like "*$trimmedApp" -and $_ -notlike "*?q=tag%3A*"} | Select-Object -first 1
        try {
            $myApps = (((Invoke-WebRequest -uri https://community.chocolatey.org$APPhref).rawcontent).split(" ")).split(">") | Select-String -Pattern ".nupkg"
        }

        Catch {}

        $AppObject = [PSCustomObject]@{
            AppName = $TrimmedApp
            PackageName = $myApps
            Description = $app.Description
            Category = $app.Category
            AppUrl = $app.URL
            DownloadURL = "https://packages.chocolatey.org/$myapps"
            HowToInstall = "choco install $myapps -y"
             } # End Custom Object
        
        $myDownloadList += $AppObject
        Invoke-WebRequest -Uri $AppObject.DownloadURL -OutFile ./"$($AppObject.PackageName)"
    }   


} # End ForEach

set-location ..
$myDownloadList | export-csv ../myDownloadList.csv -Force

<# Links below are just for reference  

https://packages.myget.org/F/fireeye/common.fireeye

https://community.chocolatey.org/packages?q=$shortapp

https://packages.chocolatey.org/

https://community.chocolatey.org/packages/wsl 

(Invoke-WebRequest -Uri https://packages.chocolatey.org/apktool.2.5.0.nupkg).raw

#>