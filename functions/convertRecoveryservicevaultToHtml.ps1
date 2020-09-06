function ConvertRecoveryservicevaultToHtml {
    param (
        $rootHtml
    )

    Write-Log "Get-AzRecoveryServicesVault"
    $allRecoveryServicesVaults = Get-AzRecoveryServicesVault
    $allRecoveryServicesVaultsHtml = ""
    
    # Recovery Service vaulat
    $allRecoveryServicesVaults | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\recoveryServicesVaultTable.eps -helpers $helpers -safe -Binding @{
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

    return $rootHtml -replace "<% allRecoveryServicesVaults -%>",$allRecoveryServicesVaultsHtml

}

