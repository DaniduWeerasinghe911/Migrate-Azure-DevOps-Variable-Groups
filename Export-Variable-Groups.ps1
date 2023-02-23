
$devOpsOrgUrl = ''
$sourceProject = ''
$targetProject = 'kk'
$groupOutputPath = 'D:\temp\sample-output.csv'
$VariablePath = 'D:\temp\'

az login 

az devops configure -d organization=$devOpsOrgUrl
az devops configure -d project=$sourceProject 


$varibleGroupDetails = az pipelines variable-group list | ConvertFrom-Json | Group-Object | Select-Object Group -ExpandProperty Group

$varibleGroupDetails | Select-Object Name,Id | Export-Csv $groupOutputPath -NoTypeInformation -NoClobber

$groups = import-csv $groupOutputPath 

foreach($g in $groups) {

     $variableGroups = az pipelines variable-group variable list --group-id $g.ID | convertfrom-json
     $variables = az pipelines variable-group variable list --group-id $g.ID | convertfrom-json | Get-Member -MemberType Properties | Select-Object Name
     $exportVariables = New-Object System.Collections.ArrayList
     foreach ($v in $variables)
     {
        if($variableGroups.($v.Name).isSecret -eq $null){
            $isSecret = $false
        }
        else {
            $isSecret = $true
        }
        #$variableGroups.($v.Name).value
        [void]$exportVariables.Add(
            [PSCustomObject]@{
                name = $v.Name
                value = $variableGroups.($v.Name).value
                isSecret = $isSecret
            }
        )
             
     }
     $fileName = $VariablePath +($g.id)+".csv"
     $exportVariables | Export-Csv $fileName -NoTypeInformation
}