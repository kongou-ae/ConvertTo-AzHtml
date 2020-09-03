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

Write-Log "Get-AzPublicIpAddress"
$allPips = Get-AzPublicIpAddress
$allPipsHtml = ""

Write-Log "Get-AzStorageAccount"
$allStorageAccounts = Get-AzStorageAccount
$allStorageAccountsHtml = ""

Write-Log "Get-AzAvailabilitySet"
$allAvailabilitySets = Get-AzAvailabilitySet
$allAvailabilitySetsHtml = ""

Write-Log "Get-AzRecoveryServicesVault"
$allRecoveryServicesVaults = Get-AzRecoveryServicesVault
$allRecoveryServicesVaultsHtml = ""

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
        Id = $_.Id.ToLower()
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
        Id = $_.Id.ToLower()        
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
        Id = $_.Id.ToLower()
    }
    $allRouteTableHtml += $row
}

$rootHtml = $rootHtml -replace "<% allRouteTables -%>",$allRouteTableHtml

# Public IP Address
$allPips | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\pipTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        Sku = $_.Sku.Name
        Version = $_.PublicIpAddressVersion
        AllocationMethod = $_.PublicIpAllocationMethod
        IpAddress = $_.IpAddress
        DnsSettings = $_.DnsSettings
        IpConfiguration = $_.IpConfiguration.Id
        Id = $_.Id.ToLower()
    }
    $allPipsHtml += $row
}

$rootHtml = $rootHtml -replace "<% allPips -%>",$allPipsHtml

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
        Id = $_.Id.ToLower()
        AvailabilitySetReference = $_.AvailabilitySetReference
        Zones = $_.Zones
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
        Id = $_.Id.ToLower()
    }
    $allDisksHtml += $row
}

$rootHtml = $rootHtml -replace "<% allDisks -%>",$allDisksHtml

# Availability Set
$allAvailabilitySets | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\avsetTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        FaultDomain = $_.PlatformFaultDomainCount
        UpdateDomain = $_.PlatformUpdateDomainCount
        VirtualMachinesReferences = $_.VirtualMachinesReferences
        Id = $_.Id.ToLower()
    }
    $allAvailabilitySetsHtml += $row

}

$rootHtml = $rootHtml -replace "<% allAvset -%>",$allAvailabilitySetsHtml

# Storage account
$allStorageAccounts | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\storageAccountTable.eps -safe -Binding @{
        Name = $_.StorageAccountName
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        Sku = $_.Sku.Name
        Kind = $_.Kind
        AccessTier = $_.AccessTier
        CustomDomain = $_.CustomDomain
        PrimaryLocation = $_.PrimaryLocation
        SecondaryLocation = $_.SecondaryLocation
        NetworkRuleSet = $_.NetworkRuleSet
        EnableHttpsTrafficOnly = $_.EnableHttpsTrafficOnly
        Id = $_.Id.ToLower()
    }
    $allStorageAccountsHtml += $row
}

$rootHtml = $rootHtml -replace "<% allStorageAccounts -%>",$allStorageAccountsHtml


# Recovery Service vaulat
$allRecoveryServicesVaults | ForEach-Object {
    $row = Invoke-EpsTemplate -Path .\templates\recoveryServicesVaultTable.eps -safe -Binding @{
        Name = $_.Name
        Location = $_.Location
        ResourceGroupName = $_.ResourceGroupName
        BackupStorageRedundancy = (Get-AzRecoveryServicesBackupProperties -Vault $_).BackupStorageRedundancy
        EnhancedSecurityState = (Get-AzRecoveryServicesVaultProperty -VaultId $_.Id).EnhancedSecurityState
        SoftDeleteFeatureState = (Get-AzRecoveryServicesVaultProperty -VaultId $_.Id).SoftDeleteFeatureState
        Id = $_.Id.ToLower()
    }
    $allRecoveryServicesVaultsHtml += $row
}

$rootHtml = $rootHtml -replace "<% allRecoveryServicesVaults -%>",$allRecoveryServicesVaultsHtml

$filename = "output_" + (Get-AzContext).Subscription.Id + "_" + (Get-date -format yyyy-MMdd-HHmm) + ".html"
$rootHtml | out-file $filename
Invoke-Item $filename