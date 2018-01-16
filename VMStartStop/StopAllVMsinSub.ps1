Select-AzureRMSubscription -SubscriptionId <xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx>
    #Write-Host $subscription.SubscriptionName
 
    foreach ($vm in Get-AzureRmVM)
    {
        $name = $vm.Name
        $RGName = $vm.ResourceGroupName
    
        If($vm.Status -ne 'StoppedDeallocated')
        {
            # Add the VM's which should not be shutdown 
            
            Write-Host 'Stopping ' + $name
            Stop-AzureRmVM -ResourceGroupName $RGName -name $name
            
        }
        # do lots of other stuff
    }
