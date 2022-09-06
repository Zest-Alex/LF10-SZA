#Prepare Enviroment
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned
Import-Module Az

Connect-AzAccount

#Variables
$location = "West Europe"
$rgname = "LF10RG01"
$vnetname = "LF10VNET01"
$subnetname = "LF10SUBNET01"
$vmname = "LF10VM01"
$securitygroupname = "LF10SEGR01"
$publicipname = "LF10PUIP01"



#Create ResourceGroup
New-AzResourceGroup -Name $rgname -Location $location

#Create Vnet + Subnet
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetname -AddressPrefix "10.0.0.0/24"
New-AzVirtualNetwork -Name $vnetname -ResourceGroupName $rgname -Location $location -AddressPrefix "10.0.0.0/16" -Subnet $subnet

#Create VM
New-AzVm `
    -ResourceGroupName $rgname `
    -Name $vmname `
    -Location $location `
    -VirtualNetworkName $vnetname `
    -SubnetName $subnetname `
    -SecurityGroupName $securitygroupname `
    -PublicIpAddressName $publicipname `
    -OpenPorts 80,3389

#Install Webserver
Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId 'RunPowerShellScript' -ScriptPath '.\VMCommand.ps1'