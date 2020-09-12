function ConvertResourceGroupToHtml {
    param (
        $rootHtml
    )
    
    Write-Log "Get-AzResourceGroup"
    $allResourceGroupSets = Get-AzResourceGroup
    $allResourceGroupSetsHtml = ""
    
    # Availability Set
    $allResourceGroupSets | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\resourceGroupTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.ResourceGroupName
            Location = $_.Location
            Id = $_.ResourceId.ToLower()
        }
        $allResourceGroupSetsHtml += $row

    }

    return $rootHtml -replace "<% allResourceGroups -%>",$allResourceGroupSetsHtml

}

