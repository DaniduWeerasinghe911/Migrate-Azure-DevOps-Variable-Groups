$variableList = import-csv 'D:\temp\Downloaded\164.csv'


foreach ($var in $variableList){
    az pipelines variable-group variable create --group-id $var.Groupid --name $var.name --value $var.value
}
