Login-AzureRmAccount
 
Select-AzureRmSubscription -SubscriptionId $SubID
$Settings = @{"workspaceId"="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"};
$ProtectedSettings = @{"workspaceKey"="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"};
$RG = Get-AzureRmResourceGroup
 
foreach ($Resource in $RG.ResourceGroupName)
{
 $VMs = Get-AzureRmVM -ResourceGroupName $Resource
 ForEach ($VM in $VMs)
 {
  Set-AzureRmVMExtension -ExtensionType MicrosoftMonitoringAgent -Name MicrosoftMonitoringAgent -Publisher Microsoft.EnterpriseCloud.Monitoring `
        -ResourceGroupName $Resource -TypeHandlerVersion 1.0 -VMName $VM.Name -Location $VM.Location -ProtectedSettings $ProtectedSettings -Settings $Settings
 }
}