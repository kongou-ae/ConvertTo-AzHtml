function ConvertStorageAccountToHtml {
    param (
        $rootHtml
    )

    
    Write-Log "Get-AzStorageAccount"
    $allStorageAccounts = Get-AzStorageAccount
    $allStorageAccountsHtml = ""
    
    # Storage account
    $allStorageAccounts | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\storageAccountTable.eps -helpers $helpers -safe -Binding @{
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

    return $rootHtml -replace "<% allStorageAccounts -%>",$allStorageAccountsHtml

}

