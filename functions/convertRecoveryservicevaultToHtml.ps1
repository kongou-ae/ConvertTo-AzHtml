function ConvertRecoveryservicevaultToHtml {
    param (
        $rootHtml
    )

    Write-Log "Get-AzRecoveryServicesVault"
    $allRecoveryServicesVaults = Get-AzRecoveryServicesVault
    $allRecoveryServicesVaultsHtml = ""
    
    # Recovery Service vaulat
    $allRecoveryServicesVaults | ForEach-Object {
        $recoveryServiceVault = $_

        $rsvAllbackupItems = New-Object System.Collections.ArrayList    
        $rsvContainer = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM -VaultId $recoveryServiceVault.ID
        $rsvContainer | ForEach-Object {
            Get-AzRecoveryServicesBackupItem -VaultId $recoveryServiceVault.ID -Container $_ -WorkloadType AzureVM | ForEach-Object {
                $rsvAllbackupItems += $_
            }                
        }

        $row = Invoke-EpsTemplate -Path .\templates\recoveryServicesVaultTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            BackupStorageRedundancy = (Get-AzRecoveryServicesBackupProperties -Vault $_).BackupStorageRedundancy
            EnhancedSecurityState = (Get-AzRecoveryServicesVaultProperty -VaultId $_.Id).EnhancedSecurityState
            SoftDeleteFeatureState = (Get-AzRecoveryServicesVaultProperty -VaultId $_.Id).SoftDeleteFeatureState
            ProtectionPolicy = Get-AzRecoveryServicesBackupProtectionPolicy -VaultId $_.Id -WorkloadType AzureVM # only support AzureVM
            BackupItems = $rsvAllbackupItems
            Id = $_.Id.ToLower()
        }
        $allRecoveryServicesVaultsHtml += $row
    }

    return $rootHtml -replace "<% allRecoveryServicesVaults -%>",$allRecoveryServicesVaultsHtml

}

