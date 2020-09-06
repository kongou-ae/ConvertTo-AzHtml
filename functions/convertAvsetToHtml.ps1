function ConvertAvsetToHtml {
    param (
        $rootHtml
    )
    
    Write-Log "Get-AzAvailabilitySet"
    $allAvailabilitySets = Get-AzAvailabilitySet
    $allAvailabilitySetsHtml = ""
    
    # Availability Set
    $allAvailabilitySets | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\avsetTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            FaultDomain = $_.PlatformFaultDomainCount
            UpdateDomain = $_.PlatformUpdateDomainCount
            VirtualMachinesReferences = $_.VirtualMachinesReferences
            Id = $_.Id.ToLower()
        }
        $allAvailabilitySetsHtml += $row

    }

    return $rootHtml -replace "<% allAvset -%>",$allAvailabilitySetsHtml

}

