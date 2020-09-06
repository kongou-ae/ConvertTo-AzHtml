function ConvertAconvertLoadbalancerToHtml {
    param (
        $rootHtml
    )

    Write-Log "Get-AzLoadBalancer"
    $allLbs = Get-AzLoadBalancer
    $allLbsHtml = ""
    
    # LoadBalancer
    $allLbs | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\lbTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            FrontendIpConfigurations = $_.FrontendIpConfigurations
            BackendAddressPools = $_.BackendAddressPools
            LoadBalancingRules = $_.LoadBalancingRules
            Probes = $_.Probes
            InboundNatRules = $_.InboundNatRules
            Sku = $_.Sku
            Id = $_.Id.ToLower()
        }
        $allLbsHtml += $row
    }

    return $rootHtml -replace "<% allLbs -%>",$allLbsHtml


}

