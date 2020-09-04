# TIPS

## 正規表現を使う場合

正規表現を使った場合、マッチしないと列は描画されない

### OK

```
        <td>
            <% if ( $NetworkSecurityGroup -ne $null ) { -%>
                <% $NetworkSecurityGroup.Id -Match "networkSecurityGroups/(.*)?" -%>
                <a href="#<%= $NetworkSecurityGroup.Id.ToLower() %>">
                    <%= $Matches[1] %>
                </a>
            <% } -%>
        </td>
```

### NG

```
        <td>
            <% $NetworkSecurityGroup.Id -Match "networkSecurityGroups/(.*)?" -%>
            <a href="#<%= $NetworkSecurityGroup.Id.ToLower() %>">
                <%= $Matches[1] %>
            </a>
        </td>
```
