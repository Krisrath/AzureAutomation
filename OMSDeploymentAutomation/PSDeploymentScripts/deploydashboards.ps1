$Deployments = "OperationsDashboard", "SecurityDashboard", "WebAppDashboard"
$RG = dashboards

ForEach ($Deployment in $Deployments) 
{
New-AzureRmResourceGroupDeployment -Name $Deployment -ResourceGroupName $RG -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json -storageAccountType Standard_GRS
  }