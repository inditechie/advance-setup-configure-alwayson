<#
Note: 
	Run from any one of the cluster nodes
	
By:
	Ghufran Khan
	FB: https://www.facebook.com/GhufranKhan89
	Youtube: https://bit.ly/36DQ87d
	GitHub: https://github.com/inditechie?tab=repositories
#>
Clear-Host

$VMNames = ("N1","N2")
$ClusterIP = "10.0.0.10"
$ClusterName = "WinClus"

$DCred = Get-Credential -Message "Domain Administrator Login (Domain\User)" -UserName "XZONE\xsql"

# Enable Fail-over Clustering on all nodes
foreach ($VMName in $VMNames)
{
    Write-Warning "For VM : $VMName"
    Install-WindowsFeature -Name Failover-Clustering -IncludeAllSubFeature -IncludeManagementTools -ComputerName $VMName -Credential $DCred | Out-Null
    Install-WindowsFeature -Name RSAT-Clustering -IncludeAllSubFeature -ComputerName $VMName -Credential $DCred | Out-Null
    Get-WindowsFeature Failover* -ComputerName $VMName -Credential $DCred
    Get-WindowsFeature RSAT-Clustering* -ComputerName $VMName -Credential $DCred
    ""
}

New-Cluster -Name $ClusterName -Node $VMNames -StaticAddress $ClusterIP -NoStorage