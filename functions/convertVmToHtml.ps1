function ConvertVmToHtml {
    param (
        $rootHtml
    )
    
    Write-log "Get-AzVM"
    $allVms = Get-AzVM
    $allVmsHtml = ""
    
    # Virtual Machine
    $allVms | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\vmTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            VmSize = $_.HardwareProfile.VmSize
            OsType = $_.StorageProfile.OsDisk.OsType
            NetworkInterfaces = $_.NetworkProfile.NetworkInterfaces
            ImageReference = $_.StorageProfile.ImageReference
            OsDisk = $_.StorageProfile.OsDisk   
            DataDisks = $_.StorageProfile.DataDisks
            Id = $_.Id.ToLower()
            AvailabilitySetReference = $_.AvailabilitySetReference
            Zones = $_.Zones
        }
        $allVmsHtml += $row
    }

    return $rootHtml -replace "<% allVms -%>",$allVmsHtml


}

