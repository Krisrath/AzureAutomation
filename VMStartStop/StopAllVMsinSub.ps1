 Select-AzureSubscription -SubscriptionId 420fd085-3e46-4d03-afb0-dda04c916b0b
    #Write-Host $subscription.SubscriptionName
 
    foreach ($vm in Get-AzureVM)
    {
        $name = $vm.Name
        $servicename = $vm.ServiceName
    
        If($vm.Status -ne 'StoppedDeallocated')
        {
            # Add the VM's which should not be shutdown 
            
            Write-Host 'Stopping ' + $name
            Stop-AzureVM -Service $servicename -name $name
            
        }
        # do lots of other stuff
    }
