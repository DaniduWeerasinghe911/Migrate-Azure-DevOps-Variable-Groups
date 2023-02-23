# Migrate-Azure-DevOps-Variable-Groups
This Repo Include PowerShell Scripts relating to Migrating Azure DevOps Variable Groups

There was a requirement to Migrate Azure Devops Variable groups from one project to another. So we came up with this powershell scripts to export and import them back into the new Azure Project

We leverage Az CLi and its devops extention

https://learn.microsoft.com/en-us/cli/azure/azure-cli-reference-for-devops


## Usage - 

**Step 1**

Update the import powershell script with required parameters

1. $devOpsOrgUrl = ''

2. $sourceProject = ''

3. $targetProject = ''

4. $groupOutputPath = 'D:\temp\sample-output.csv

5. $VariablePath = 'D:\temp\'

Export Script will export all the varible groups into one csv file as per in the 4th varible and also export all the varibles in the varible groups into seperate files with varible group ID as per in the 5th parameter locations.

**Step 2**

In our case we had to upload them into new Varible groups with seperate names, So prior to uploading the varible, we had to create the new groups in the new Devops project manually. But if you would like to create them using the same name by all means it can be easily achived using the

