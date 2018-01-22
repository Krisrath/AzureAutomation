#Login-AzureRmAccount
#Get-AzureRmSubscription -SubscriptionId xxxxxxxxxxxxxxxxxxxxxxxxxxxxx | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId 420fd085-3e46-4d03-afb0-dda04c916b0b
## Customize for Your Environment
$ResourceGroupName = "ManageIQTest"
$StorageAccountName = "horizonimagestore"
$BlobNameDest = "manageiq-azure-fine-4.vhd"
$BlobDestinationContainer = "images"
$VMName = "manageiq-test"
$DeploySize= "Standard_D2_V3"
$vmUserName = "admin"
$Location = 'eastus2'

$InterfaceName = "manageIQ-nic"
$VNetName = "adVNET"
$PublicIPName = "manageiq-test-public-ip"

$SSHKey = 

##

$StorageAccount = Get-AzureRmStorageAccount -ResourceGroup 'HorizonTest' -Name $StorageAccountName

$SourceImageUri = "https://$StorageAccountName.blob.core.windows.net/$BlobNameSource"
$Location = $StorageAccount.Location
$OSDiskName = $VMName

# Network
$PIp = New-AzureRmPublicIpAddress -Name $PublicIPName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -Force
$VNet = 'adVNET'
$Subnet = 'adSubnet'
$Interface = New-AzureRmNetworkInterface -Name $InterfaceName -ResourceGroupName $ResourceGroupName -Location $Location -Subnet $Subnet -PublicIpAddressId $PIp.Id -Force

# Specify the VM Name and Size
$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $DeploySize

# Add User
$cred = Get-Credential -UserName $VMUserName -Message "Setting user credential - use blank password"
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Linux -ComputerName $VMName -Credential $cred

# Add NIC
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $Interface.Id

# Add Disk
$OSDiskUri = $StorageAccount.PrimaryEndpoints.Blob.ToString() + $BlobDestinationContainer + "/" + $BlobNameDest

$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $OSDiskName -VhdUri $OSDiskUri -CreateOption fromImage -SourceImageUri $SourceImageUri -Linux

# Set SSH key
Add-AzureRmVMSshPublicKey -VM $VirtualMachine -Path “/home/$VMUserName/.ssh/authorized_keys” -KeyData $SSHKey

# Create the VM
New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VirtualMachine