# ZabbixWinAgentDeploy
Powershellscript for deploying Zabbix agents on Windows Computers/Servers.

First, download the agentversion you want to use.
Put this inside a folder, preferably on a reachable network share.
This would be your $zabbixPath

Alter the script so the params fit your need.

Run, and see if the script returns that the service is running or not.

# General usage
.\ZabbixWindowsAgentInstall.ps1 -computername srv1,srv2,srv3
