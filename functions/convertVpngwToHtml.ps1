function ConvertVpngwToHtml {
    param (
        $rootHtml
    )

    Write-log "Get-AzResourceGroup | Get-AzVirtualNetworkGateway"
    $allVpngws = Get-AzResourceGroup | Get-AzVirtualNetworkGateway
    $allVpngwsHtml = ""
    
    # Virtual Network
    $allVpngws | ForEach-Object {
        $row = invoke-EpsTemplate -Path .\templates\vpngwTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            GatewayType = $_.GatewayType
            VpnType = $_.VpnType
            SKu = $_.Sku.Name
            EnableBgp = $_.EnableBgp
            ActiveActive = $_.ActiveActive
            GatewayDefaultSite = $_.GatewayDefaultSite
            BgpSettings = $_.BgpSettings
            IpConfigurations = $_.IpConfigurations
        }
        $allVpngwsHtml += $row
    }
    
    return $rootHtml -replace "<% allVpngws -%>",$allVpngwsHtml

}

