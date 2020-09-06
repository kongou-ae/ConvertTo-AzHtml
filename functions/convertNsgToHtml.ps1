function ConvertNsgToHtml {
    param (
        $rootHtml
    )

    
    Write-log "Get-AzNetworkSecurityGroup"
    $allNsgs = Get-AzNetworkSecurityGroup
    $allNsgsHtml = ""
    
    $allNsgs | ForEach-Object {
        $row = Invoke-EpsTemplate -Path .\templates\nsgTable.eps -helpers $helpers -safe -Binding @{
            Name = $_.Name
            Location = $_.Location
            ResourceGroupName = $_.ResourceGroupName
            SecurityRules = $_.SecurityRules | Sort-Object Direction,Priority 
            Id = $_.Id.ToLower()        
        }
        $allNsgsHtml += $row
    }

    return $rootHtml -replace "<% allNsgs -%>",$allNsgsHtml

}

