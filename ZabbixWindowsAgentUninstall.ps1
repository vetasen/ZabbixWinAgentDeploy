
[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[array]$computerName
)

$zabbixService = "Zabbix Agent"
$zabbixHome = "C:\zabbix"

foreach ($computer in $computerName){

    #See if computer is reachable
    try {
    $pingCheck = Test-Connection -cn $computer -ErrorAction STOP
    }
    catch {
    $errorMsg = $_.exception.message
    write-host "----------------------------------------------------------------------------------------"
    write-host "SCRIPT STOPPER: Klarer ikke nå $computer. Feilmelding: $errorMsg"
    write-host "----------------------------------------------------------------------------------------"
    exit
    }
    
    #See if service is existing
    try {
    $serviceCheck = get-service -cn $computer -name $zabbixService -ErrorAction STOP
    }
    catch {
    $errorMsg = $_.exception.message
    write-host "----------------------------------------------------------------------------------------"
    write-host "SCRIPT STOPPER: Finner ikke Zabbix Agent på server $computer. Get-service retur: $errorMsg"
    write-host "----------------------------------------------------------------------------------------"
    exit
    }

        # Determine OS-bitversion
    if ([System.IntPtr]::Size -eq 4)
    {
        echo "System is 32-bit"
        $osVersion = "win32"
    }
    else
    {
        echo "System is 64-bit"
        $osVersion = "win64"
    }

    #If all above is OK, create uninstallerstring and uninstall service
    $stopString =  "$zabbixHome\$osversion\zabbix_agentd.exe -c c:\zabbix\zabbix_agentd.win.conf -x"
    $remoteWMI = Invoke-WMIMethod -Class Win32_Process -Name Create -Computername $computer -ArgumentList $stopString
    sleep -seconds 3
    $uninstallString = "$zabbixHome\$osversion\zabbix_agentd.exe -c c:\zabbix\zabbix_agentd.win.conf -d"
    $remoteWMI = Invoke-WMIMethod -Class Win32_Process -Name Create -Computername $computer -ArgumentList $uninstallString
    sleep -seconds 3
    Remove-Item $zabbixHome -Recurse
    write-host "----------------------------------------------------------------------------------------"
    write-host "Service stopped, deleted and folder removed. Logfile will still exist under C:\"
    write-host "----------------------------------------------------------------------------------------"


} #End foreach