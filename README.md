# Important
The running user must have adminrights on target servers.

# ZabbixWindowsAgentInstall
Powershellscript for deploying Zabbix agents on Windows Computers/Servers.

First, download the agentversion you want to use.
Put this inside a folder, preferably on a reachable network share.
This would be your $zabbixPath

Alter the script so the params fit your need.

Run, and see if the script returns that the service is running or not.

# General usage
- .\ZabbixWindowsAgentInstall.ps1
- Enter computernames, separated by pressing the Return key.
- When done, hit return once again (empty string), and script will run.


# ZabbixWindowsAgentUninstall
Powershellscript for uninstalling previously deployed Zabbix Agents.

Alter the script so the params fit your need.

Run, and see if the script returns and OK message or not.

# General usage
- .\ZabbixWindowsAgentUninstall.ps1
- Enter computernames, separated by pressing the Return key.
- When done, hit return once again (empty string), and the script will run.