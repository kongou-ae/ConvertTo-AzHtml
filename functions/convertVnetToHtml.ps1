function ConvertVnetToHtml {
    param (
        $rootHtml
    )

    Write-log "Get-AzVirtualNetwork"
    $allVnets = Get-AzVirtualNetwork
    $allVnetsHtml = ""
    
    # Virtual Network
    $allVnets | ForEach-Object {
        $row = invoke-EpsTemplate -Path .\templates\vnetTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            AddressSpace = $_.AddressSpace.AddressPrefixes
            Subnets = $_.Subnets
        }
        $allVnetsHtml += $row
    }
    
    return $rootHtml -replace "<% allVnets -%>",$allVnetsHtml

}

