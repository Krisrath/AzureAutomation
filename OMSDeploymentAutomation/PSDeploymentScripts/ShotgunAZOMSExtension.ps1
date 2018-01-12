#Login-AzureRmAccount
 
#Select-AzureRmSubscription -SubscriptionId $SubID
$Settings = @{"workspaceId"="bb1389d0-1c8c-41f8-b950-96f1dafc4068"};
$ProtectedSettings = @{"workspaceKey"="zbSyHRz7TEXf3xkUSpdzq4qLFCwp6V8Mxw0AJzpOJLrT6MvqL1AUt9eFN2G7po6/cwl9sHqaHyQKVA5KnTuCGw=="};
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