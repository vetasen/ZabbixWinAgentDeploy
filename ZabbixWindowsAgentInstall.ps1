
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[array]$computerName,
	[string]$zabbixPath = "<Zabbix Agent Path>",
	[string]$zabbixVersion = "3.2"
)

$zabbixService = "Zabbix Agent"
$zabbixSource = "$zabbixPath\$zabbixVersion"
$zabbixServerIP = "10.0.0.178"


foreach ($computer in $computerName){
    $zabbixHome = "\\$computer\c$\zabbix"
    # Create Zabbix Home folder
    if ((Test-Path -Path $zabbixHome) -eq $false)
    {
        echo "Folder not present - creating zabbixfolder"
        New-Item $zabbixHome -ItemType Directory
    }

    # Determine OS-bitversion
    if ([System.IntPtr]::Size -eq 4)
    {
        echo "System is 32-bit"
        cp "$zabbixSource\win32" $zabbixHome -recurse
    }
    else
    {
        echo "System is 64-bit"
        cp "$zabbixSource\win64" $zabbixHome -recurse
        $osVersion = "win64"
    }

    # Create Configfile for $Computer
    $templateConfig = "$zabbixSource\zabbix_agentd.win.conf"
    $newConfig = "$zabbixHome\zabbix_agentd.win.conf"

    (Get-Content $templateConfig) | ForEach-Object {
         $_ -replace "Server=127.0.0.1","Server=$zabbixServerIP" `
            -replace "LogFile=c:\zabbix_agentd.log","LogFile=c:\zabbix\zabbix_agentd.log" `
            -replace "ServerActive=127.0.0.1","ServerActive=$zabbixServerIP" `
            -replace "Hostname=","Hostname=$Computer" `
            -replace "# HostMetadataItem=","HostMetadataItem=system.uname"
            } | set-content $newConfig

    # Creating installer and servicestrings
    $installerString =  "$zabbixHome\$osversion\zabbix_agentd.exe -c c:\zabbix\zabbix_agentd.win.conf -i"
    $serviceString = "$zabbixHome\$osversion\zabbix_agentd.exe -c c:\zabbix\zabbix_agentd.win.conf -s"
	
    # Execute install string
    # OBS - HER ER DET ROM FOR MYE GOD FEILMELDINGSHÅNDTERING....
	$remoteWMI = Invoke-WMIMethod -Class Win32_Process -Name Create -Computername $computer -ArgumentList $installerString
	sleep -second 3
    # Execute service string
    $remoteWMI = Invoke-WMIMethod -Class Win32_Process -Name Create -Computername $computer -ArgumentList $serviceString
    sleep -second 5

    # Check if service is running
		try
		{
			$InstallStatus = Get-Service -ComputerName $computer -Name $ZabbixService
		}
		catch
		{
			Write-Host " Problem while verifying service!"
			Write-Host " Error! " $_
			$instBad += $computer + " "
			continue
		}
		if ($InstallStatus.Status -eq "Running")
		{
			Write-Host " Service installed and started!"
		}
		else
		{
			Write-Host " Service installed but not started!"
			Write-Host " Service state: " $InstallStatus.Status
		}
    
} #End foreach