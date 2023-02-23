<#
.SYNOPSIS
Script to import variable values from CSV files and create Azure DevOps variable groups and variables.

.DESCRIPTION
This script imports variable values from CSV files and creates Azure DevOps variable groups and variables. The script takes a folder path as input and scans for CSV files. For each file, it imports the CSV contents and creates variables in an Azure DevOps variable group. 

.PARAMETER folderPath
The folder path to scan for CSV files.

.NOTES
Author: Danidu Weerasinghe
Date: 24/02/2023

.EXAMPLE
.\Create-VariableGroups.ps1 -folderPath "D:\temp"

#>

# Define the folder path to scan for CSV files
param (
    [Parameter(Mandatory=$true)]
    [string]$folderPath
)

# Get all CSV files in the specified folder
$fileList = Get-ChildItem -Path $FolderPath -Filter *.csv

# Loop through each CSV file and create variables in Azure DevOps
foreach($file in $fileList){

    # Build the file path
    $filePath = Join-Path -Path $folderPath -ChildPath $file.name

    # Import the CSV file
    $variableList = Import-Csv -Path $filePath

    # Loop through each variable in the CSV file and create an Azure DevOps variable
    foreach ($var in $variableList){
        az pipelines variable-group variable create --group-id $var.Groupid --name $var.name --value $var.value
    }
}
