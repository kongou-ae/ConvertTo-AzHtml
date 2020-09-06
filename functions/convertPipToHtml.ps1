function ConvertPipToHtml {
    param (
        $rootHtml
    )

    Write-Log "Get-AzPublicIpAddress"
    $allPips = Get-AzPublicIpAddress
    $allPipsHtml = ""    

    # Public IP Address
    $allPips | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\pipTable.eps -helpers $helpers -safe -Binding @{
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

    return $rootHtml -replace "<% allPips -%>",$allPipsHtml

}

