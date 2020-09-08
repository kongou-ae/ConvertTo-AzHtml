function ConvertNicToHtml {
    param (
        $rootHtml
    )

    
    Write-log "Get-AzNetworkInterface"
    $allNics = Get-AzNetworkInterface
    $allNicsHtml = ""
    
    # Network Interface
    $allNics | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\nicTable.eps -helpers $helpers -safe -Binding @{
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

    return $rootHtml -replace "<% allNics -%>",$allNicsHtml

}

