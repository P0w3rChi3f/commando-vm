$apps = Import-Csv ./packages.csv
$myDownloadList = @()

foreach ($app in $apps) {

    $TrimmedApp = [System.IO.Path]::GetFileNameWithoutExtension((($app)."PackageName"))

    # Code here does a search on Chocolatey for nupkg apps
    $APPhref = (Invoke-WebRequest  -Uri https://community.chocolatey.org/packages?q=$TrimmedApp).links.href | Where-Object {$_ -like "*$trimmedApp" -and $_ -notlike "*?q=tag%3A*"} | Select-Object -first 1
    #$APPhref

    # Need code to search for non-nupkg apps

    try {
        # Code here gets the download path from Chocolatey for nupkg's 
       $myApps = (((Invoke-WebRequest -uri https://community.chocolatey.org$APPhref).rawcontent).split(" ")).split(">") | Select-String -Pattern ".nupkg"
       
       # Need to get download links for non-nupkg's

       
        } # End Try Block
    catch {
       
        } # end Catch Block
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
} # End Foreach

$myDownloadList | export-csv ./myDownloadList.csv -Force

#>


<#
https://packages.myget.org/F/fireeye/common.fireeye

https://community.chocolatey.org/packages?q=$shortapp

https://packages.chocolatey.org/

https://community.chocolatey.org/packages/wsl 

(Invoke-WebRequest -Uri https://packages.chocolatey.org/apktool.2.5.0.nupkg).raw

#>