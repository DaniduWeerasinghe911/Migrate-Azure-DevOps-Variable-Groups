<#
.SYNOPSIS
   This script exports Azure DevOps variable group variables to CSV files.

.DESCRIPTION
   This script exports all the variables from every variable group in the specified Azure DevOps organization and project
   and saves them in separate CSV files in the specified directory.

.PARAMETER devOpsOrgUrl
   The URL of the Azure DevOps organization.

.PARAMETER sourceProject
   The name of the project in which the variable groups are located.

.PARAMETER targetProject
   The name of the project to which the variable groups will be imported.

.PARAMETER groupOutputPath
   The path where the output CSV file containing the list of variable groups will be saved.

.PARAMETER VariablePath
   The directory where the CSV files containing the variables will be saved.

.EXAMPLE
   .\Export-AzureDevOpsVariableGroups.ps1 -devOpsOrgUrl "https://dev.azure.com/myOrg" -sourceProject "myProject" -targetProject "myProject2" -groupOutputPath "D:\temp\sample-output.csv" -VariablePath "D:\temp\"

.NOTES
   Author: Danidu Weerasinghe
   Date: 24/02/2023
#>

# Define the parameters
param(
    [string]$devOpsOrgUrl,
    [string]$sourceProject,
    [string]$targetProject,
    [string]$groupOutputPath,
    [string]$VariablePath
)

# Log in to Azure DevOps
az login 
az devops configure -d organization=$devOpsOrgUrl
az devops configure -d project=$sourceProject 

# Get the list of variable groups and save it to a CSV file
$varibleGroupDetails = az pipelines variable-group list | ConvertFrom-Json | Group-Object | Select-Object Group -ExpandProperty Group
$varibleGroupDetails | Select-Object Name,Id | Export-Csv $groupOutputPath -NoTypeInformation -NoClobber

# Import the list of variable groups and iterate over each group to export the variables to a CSV file
$groups = import-csv $groupOutputPath 
foreach($g in $groups) {

     # Get the variables of the current variable group and iterate over each variable to export its details to the CSV file
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
        
        # Add the variable details to the array list
        [void]$exportVariables.Add(
            [PSCustomObject]@{
                name = $v.Name
                value = $variableGroups.($v.Name).value
                isSecret = $isSecret
            }
        )
             
     }
     
     # Save the variable details to a CSV file
     $fileName = $VariablePath +($g.id)+".csv"
     $exportVariables | Export-Csv $fileName -NoTypeInformation
}
