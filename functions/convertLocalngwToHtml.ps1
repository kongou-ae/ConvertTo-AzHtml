function ConvertLocalngwToHtml {
    param (
        $rootHtml
    )

    Write-log "Get-AzResourceGroup | Get-AzLocalNetworkGateway"
    $allLocalngws = Get-AzResourceGroup | Get-AzLocalNetworkGateway
    $allLocalngwsHtml = ""
    
    # Virtual Network
    $allLocalngws | ForEach-Object {
        $row = invoke-EpsTemplate -Path .\templates\localngwTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            GatewayIpAddress = $_.GatewayIpAddress
            LocalNetworkAddressSpace = $_.LocalNetworkAddressSpace
            BgpSettings = $_.BgpSettings
        }
        $allLocalngwsHtml += $row
    }
    
    return $rootHtml -replace "<% allLocalngws -%>",$allLocalngwsHtml

}

