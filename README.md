# PowerShell Script - Import Azure DevOps Variable Groups

## Description
This scripts exports and imports variables from CSV files located in a specified directory into Azure DevOps variable groups. The script assumes that each CSV file represents a variable group, and the name of the CSV file is the ID of the variable group.

## Author
[Danidu Weerasinghe](https://github.com/DaniduWeerasinghe911)

## Usage
1. Modify the `folderPath` variable to specify the directory where the CSV files are located.
2. Run the script in a PowerShell console.

## Requirements
- Azure PowerShell module (Az)
- An Azure DevOps organization with appropriate permissions to manage variable groups

## Inputs
- `folderPath` - A string representing the directory path where CSV files are located.

## Outputs
- The script will create or update the variable groups in Azure DevOps with the variables specified in the CSV files.

# Migrate-Azure-DevOps-Variable-Groups
This Repo Include PowerShell Scripts relating to Migrating Azure DevOps Variable Groups

There was a requirement to Migrate Azure Devops Variable groups from one project to another. So we came up with this powershell scripts to export and import them back into the new Azure Project

We leverage Az CLi and its devops extention

https://learn.microsoft.com/en-us/cli/azure/azure-cli-reference-for-devops


## Usage - 

**Step 1**

## Parameters

| Parameter Name | Description |
| --- | --- |
| `devOpsOrgUrl` | The URL of the Azure DevOps organization to connect to |
| `sourceProject` | The name of the source project to copy the variable groups from |
| `targetProject` | The name of the target project to copy the variable groups to |
| `groupOutputPath` | The path to save the list of variable group IDs and names as a CSV file |
| `VariablePath` | The path to save the exported variable group variables as CSV files |

## Usage

```powershell
./<Script Name>.ps1 -devOpsOrgUrl "<devOpsOrgUrl>" -sourceProject "<sourceProject>" -targetProject "<targetProject>" -groupOutputPath "<groupOutputPath>" -VariablePath "<VariablePath>" 
```

Export Script will export all the varible groups into one csv file as per in the 4th varible and also export all the varibles in the varible groups into seperate files with varible group ID as per in the 5th parameter locations.

**Step 2**

In our case we had to upload them into new Varible groups with seperate names, So prior to uploading the varible, we had to create the new groups in the new Devops project manually. But if you would like to create them using the same name by all means it can be easily achived using the az cli devops commands

As per our requirment, we had to update the exported excel sheet by adding the target varible group id into each row with a varible under a new colum name

![azurearchitecture-Landing-Zones.jpg](./images/1.png)



**Step 3**

Once all the groups are updated with target group Id.

Update the Parameter to on the import script to reflect the folder path where the update files are located

## Example
```powershell
$folderPath = 'C:\VariableGroups'
Import-AzDevOpsVariableGroups -FolderPath $folderPath
```