function ConvertVnetconToHtml {
    param (
        $rootHtml
    )

    Write-log "Get-AzResourceGroup | Get-AzVirtualNetworkGatewayConnection"
    $allVnetcons = Get-AzResourceGroup | Get-AzVirtualNetworkGatewayConnection
    $allVnetconsHtml = ""
    
    # Virtual Network
    $allVnetcons | ForEach-Object {
        $row = invoke-EpsTemplate -Path .\templates\vnetconTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            VirtualNetworkGateway1 = $_.VirtualNetworkGateway1
            VirtualNetworkGateway2 = $_.VirtualNetworkGateway2
            LocalNetworkGateway2 = $_.LocalNetworkGateway2
            AuthorizationKey = $_.AuthorizationKey
            SharedKey = Get-AzVirtualNetworkGatewayConnectionSharedKey -ResourceName $_.Name -ResourceGroupName $_.ResourceGroupName
            Peer = $_.Peer
            RoutingWeight = $_.RoutingWeight
            Id = $_.Id
        }
        $allVnetconsHtml += $row
    }
    
    return $rootHtml -replace "<% allVnetcons -%>",$allVnetconsHtml

}

