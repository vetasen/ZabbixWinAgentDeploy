# Prepare Zabbix for autodiscovery of agents

Make sure you have the Zabbix server identified in the agent configuration file - zabbix_agentd.conf
ServerActive=<your Zabbix Server IP>

Then, add the following to the agent configuration file - zabbix_agentd.conf
HostMetadataItem=system.uname

This way you make sure host metadata will contain “Linux” or “Windows” depending on the host an agent is running on. An example of host metadata in this case:

Linux: Linux server3 3.2.0-4-686-pae #1 SMP Debian 3.2.41-2 i686 GNU/Linux
Windows: Windows WIN-0PXGGSTYNHO 6.0.6001 Windows Server 2008 Service Pack 1 Intel IA-32

# Frontend configuration

Now you need to configure the frontend. Log on to webconsole.
Create 2 actions. The first action:

Name: Linux host autoregistration
Conditions: Host metadata like Linux
Operations: Link to templates: Template OS Linux
You can skip an “Add host” operation in this case. Linking to a template requires adding a host first so the server will do that automatically.

The second action:

Name: Windows host autoregistration
Conditions: Host metadata like Windows
Operations: Link to templates: Template OS Windows

Restart the agent on the host, and you will see that agents are discovered and assigned a template automatically.