$Deployment1 = "dashboards"
$Dashboards = "OperationsDashboard", "SecurityDashboard", "WebAppDashboard"
$Location = "EastUS"
$AzureRG = OMS-TestAutomation
$AAA = AGI-TestAutoAcc

New-AzureRmAutomationAccount -ResourceGroupName $AzureRG -Location $Location -Name $AAA

ForEach ($Dashboard in $Dashboards) 
{
New-AzureRmResourceGroupDeployment -Name $Deployment1 -ResourceGroupName $AzureRG -TemplateUri https://raw.githubusercontent.com/Krisrath/AzureAutomation/master/OMSDeploymentAutomation/OMSDashboardTemplates/$Dashboard.json -storageAccountType Standard_LRS
  }
  