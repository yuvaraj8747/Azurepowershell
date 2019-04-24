Clear-Host
	
#Connect Azure Portal
Connect-AzureRmAccount
Write-Host "Azure Portal Connected" -ForegroundColor Green

#Declare CSV File Location
$path = "D:\AZ2.csv"

#Declaring User name And password for VM machines
$UserName='AdminUser'
$Password='Password@123'| ConvertTo-SecureString -Force -AsPlainText
$Credential=New-Object PSCredential($UserName,$Password)

#Import Excel Data's
$info = Import-Csv -Path $path
Write-Host "CSV File Imported" -ForegroundColor Green

Foreach($details in $info)
{
    $ResourceName = $($details.Resource_Name)
    $VMName = $($details.VMName)
    $Loc = $($details.Location)
    $VMNET = $($details.VirtualNetworkName)
    $subnet = $($details.Subnet)
    $security = $($details.SecurityGrupName)
    $ip = $($details.publicAddressname)
    $port = $($details.Ports).ToString()
    Write-Host "Creating $VMName Machine" -ForegroundColor Green
    New-AzureRmVM -ResourceGroupName $ResourceName -Name $VMName -Location $Loc -VirtualNetworkName $VMNET -SubnetName $subnet -SecurityGroupName $security -PublicIpAddressName $ip -OpenPorts $port -Credential $Credential
}
