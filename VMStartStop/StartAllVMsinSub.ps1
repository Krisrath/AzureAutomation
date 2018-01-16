Select-AzureRMSubscription -SubscriptionId <xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx>
    #Write-Host $subscription.SubscriptionName
 
    foreach ($vm in Get-AzureRmVM)
    {
        $name = $vm.Name
        $RGName = $vm.ResourceGroupName
    
        If($vm.Status -ne 'Running')
        {
            # Add the VM's which should not be shutdown 
            
            Write-Host 'Starting ' + $name
            Start-AzureRmVM -ResourceGroupName $RGName -name $name
            
        }
        # do lots of other stuff
    }
