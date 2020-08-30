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

# initialize

Write-log "Get-AzVirtualNetwork"
$allVnets = Get-AzVirtualNetwork
$allVnetsHtml = ""

Write-log "Get-AzNetworkInterface"
$allNics = Get-AzNetworkInterface
$allNicsHtml = ""

Write-log "Get-AzVM"
$allVms = Get-AzVM
$allVmsHtml = ""

Write-log "Get-AzNetworkSecurityGroup"
$allNsgs = Get-AzNetworkSecurityGroup
$allNsgsHtml = ""

Write-Log "Get-AzRouteTable"
$allRoutes = Get-AzRouteTable
$allRouteTableHtml = ""

Write-log "Get-AzDisk"
$allDisks = Get-AzDisk
$allDisksHtml = ""

# Virtual Network
$allVnets | ForEach-Object {
    $row = invoke-EpsTemplate -Path .\templates\vnetTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        AddressSpace = $_.AddressSpace.AddressPrefixes
        Subnets = $_.Subnets
    }
    $allVnetsHtml += $row
}

$rootHtml = $rootHtml -replace "<% allVnets -%>",$allVnetsHtml

# Network Interface
$allNics | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\nicTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        IpConfigurations = $_.IpConfigurations
        DnsSettings = $_.DnsSettings
        EnableIPForwarding = $_.EnableIPForwarding
        NetworkSecurityGroup = $_.NetworkSecurityGroup
        Id = $_.Id
    }
    $allNicsHtml += $row
}

$rootHtml = $rootHtml -replace "<% allNics -%>",$allNicsHtml

# Network Security Group
$allNsgs | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\nsgTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        SecurityRules = $_.SecurityRules | Sort-Object Direction,Priority 
        Id = $_.Id        
    }
    $allNsgsHtml += $row
}

$rootHtml = $rootHtml -replace "<% allNsgs -%>",$allNsgsHtml

# Route table
$allRoutes | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\routeTableTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        Routes = $_.Routes
        Subnets = $_.Subnets
        Id = $_.Id
    }
    $allRouteTableHtml += $row
}

$rootHtml = $rootHtml -replace "<% allRouteTables -%>",$allRouteTableHtml

# Virtual Machine

$allVms | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\vmTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        VmSize = $_.HardwareProfile.VmSize
        OsType = $_.StorageProfile.OsDisk.OsType
        NetworkInterfaces = $_.NetworkProfile.NetworkInterfaces
        ImageReference = $_.StorageProfile.ImageReference
        OsDisk = $_.StorageProfile.OsDisk   
        DataDisks = $_.StorageProfile.DataDisks
        Id = $_.Id
    }
    $allVmsHtml += $row
}

$rootHtml = $rootHtml -replace "<% allVms -%>",$allVmsHtml

# Disk

$allDisks | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\diskTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        Sku = $_.Sku
        ManagedBy = $_.ManagedBy
        DiskSizeGB = $_.DiskSizeGB
        DiskState = $_.DiskState
        Id = $_.Id
    }
    $allDisksHtml += $row
}

$rootHtml = $rootHtml -replace "<% allDisks -%>",$allDisksHtml

$filename = "output_" + (Get-AzContext).Subscription.Id + "_" + (Get-date -format yyyy-MMdd-HHmm) + ".html"
$rootHtml | out-file $filename
Invoke-Item $filename