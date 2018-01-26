#Login-AzureRmAccount
#Get-AzureRmSubscription -SubscriptionId xxxxxxxxxxxxxxxxxxxxxxxxxxxxx | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
## Customize for Your Environment
$ResourceGroupName = "ManageIQTest"
$StorageAccountName = "horizonimagestore"
$BlobNameSource = "manageiq-azure-fine-4fixed.vhd"
$BlobNameDest = "manageiqosdsk0.vhd"
$BlobDestinationContainer = "images"
$VMName = "manageiq-test"
$DeploySize= "Standard_D2_V3"
$vmUserName = "manageiqadmin"
$Location = 'eastus2'

$InterfaceName = "manageIQ-nic"
$VNet = Get-AzureRmVirtualNetwork -Name adVNET -ResourceGroupName HorizonTest
$Subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name adSubnet -VirtualNetwork $VNet
$PublicIPName = "manageiq-test-public-ip"

$SSHKey = 

##

$StorageAccount = Get-AzureRmStorageAccount -ResourceGroup 'HorizonTest' -Name $StorageAccountName

$SourceImageUri = "https://$StorageAccountName.blob.core.windows.net/images/$BlobNameSource"
$Location = $StorageAccount.Location
$OSDiskName = $VMName

# Network
$PIp = New-AzureRmPublicIpAddress -Name $PublicIPName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -Force
#$Subnet = 'adSubnet'
#$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -Subnet $Subnet -PublicIpAddressId $PIp.Id -Force
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -SubnetId $Subnet.Id -PublicIpAddressId $PIp.Id -Force
# Specify the VM Name and Size
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $DeploySize

# Add User
$cred = Get-Credential -UserName $VMUserName -Message "Setting user credential - use blank password"
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Linux -ComputerName $VMName -Credential $cred

# Add NIC
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id

# Add Disk
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + $BlobDestinationContainer + "/" + $BlobNameDest

$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -DiskSizeInGB '127' -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption fromImage -SourceImageUri $SourceImageUri -Linux

# Set SSH key
Add-AzureRmVMSshPublicKey -VM $VirtualMachine -Path “/home/$VMUserName/.ssh/authorized_keys” -KeyData $SSHKey

# Create the VM
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine