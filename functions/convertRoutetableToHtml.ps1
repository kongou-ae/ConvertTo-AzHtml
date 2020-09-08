function ConvertRouteTableToHtml {
    param (
        $rootHtml
    )

    
    Write-Log "Get-AzRouteTable"
    $allRoutes = Get-AzRouteTable
    $allRouteTableHtml = ""

    # Route table
    $allRoutes | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\routeTableTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            Routes = $_.Routes
            Subnets = $_.Subnets
            Id = $_.Id.ToLower()
        }
        $allRouteTableHtml += $row
    }

    return $rootHtml -replace "<% allRouteTables -%>",$allRouteTableHtml


}

