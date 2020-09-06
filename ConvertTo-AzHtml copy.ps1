$ErrorActionPreference = "stop"

$rootHtml = Get-content .\templates\index.html

Function Write-Log
{
    param(
    [string]$Message,
    [string]$Color = 'White'
    )

    $Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$Date] $Message" -ForegroundColor $Color
}

. .\functions\convertVnetToHtml.ps1
. .\functions\convertNsgToHtml.ps1
. .\functions\convertNicToHtml.ps1
. .\functions\convertVmToHtml.ps1
. .\functions\ConvertPipToHtml.ps1
. .\functions\ConvertRoutetableToHtml.ps1
. .\functions\ConvertDiskToHtml.ps1
. .\functions\ConvertAvsetToHtml.ps1
. .\functions\ConvertRecoveryservicevaultToHtml.ps1
. .\functions\convertStorageAccountToHtml.ps1
. .\functions\ConvertLoadbalancerToHtml.ps1

$rootHtml = ConvertVnetToHtml $rootHtml
$rootHtml = convertNsgToHtml $rootHtml
$rootHtml = convertNicToHtml $rootHtml
$rootHtml = convertVmToHtml $rootHtml
$rootHtml = convertPipToHtml $rootHtml
$rootHtml = convertRoutetableToHtml $rootHtml
$rootHtml = convertDiskToHtml $rootHtml
$rootHtml = convertAvsetToHtml $rootHtml
$rootHtml = ConvertRecoveryservicevaultToHtml $rootHtml
$rootHtml = ConvertAconvertLoadbalancerToHtml $rootHtml
$rootHtml = ConvertStorageAccountToHtml $rootHtml


$filename = "output_" + (Get-AzContext).Subscription.Id + "_" + (Get-date -format yyyy-MMdd-HHmm) + ".html"
$rootHtml | out-file $filename
Invoke-Item $filename