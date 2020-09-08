function ConvertDiskToHtml {
    param (
        $rootHtml
    )
    
    Write-log "Get-AzDisk"
    $allDisks = Get-AzDisk
    $allDisksHtml = ""
    
    # Disk
    $allDisks | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\diskTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            Sku = $_.Sku
            ManagedBy = $_.ManagedBy
            DiskSizeGB = $_.DiskSizeGB
            DiskState = $_.DiskState
            Id = $_.Id.ToLower()
        }
        $allDisksHtml += $row
    }

    return $rootHtml -replace "<% allDisks -%>",$allDisksHtml

}

