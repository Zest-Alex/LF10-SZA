#Prepare Enviroment
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned
Install-Module Az
Import-Module Az
Update-Module -name Az.Compute -RequiredVersion 4.28.0

Connect-AzAccount

#Variables
$location = "West Europe"
$rgname = "LF10RG01"
$vnetname = "LF10VNET01"
$subnetname = "LF10SUBNET01"
$vmname = "LF10VM01"
$segrname = "LF10SEGR01"
$puipname = "LF10PUIP01"



#Create ResourceGroup
Write-Host "Creating ResourceGroup $rgname"
New-AzResourceGroup -Name $rgname -Location $location

#Create Vnet + Subnet
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetname -AddressPrefix "10.0.0.0/24"
New-AzVirtualNetwork -Name $vnetname -ResourceGroupName $rgname -Location $location -AddressPrefix "10.0.0.0/16" -Subnet $subnet

#Create VM 01
New-AzVm `
    -ResourceGroupName $rgname `
    -Name $vmname `
    -Location $location `
    -VirtualNetworkName $vnetname `
    -SubnetName $subnetname `
    -SecurityGroupName $segrname `
    -PublicIpAddressName $puipname `
    -OpenPorts 80,3389

#Install Webserver
Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId 'RunPowerShellScript' -ScriptPath '.\VMCommand.ps1'