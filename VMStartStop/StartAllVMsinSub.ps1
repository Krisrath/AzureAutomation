Select-AzureRMSubscription -SubscriptionId 420fd085-3e46-4d03-afb0-dda04c916b0b
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
