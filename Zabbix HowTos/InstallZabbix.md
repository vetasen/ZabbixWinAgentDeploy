 How to install Zabbix on Ubuntu 16.04 Server

Update your system
*********************
sudo apt-get update

Install LAMP stack
*********************
sudo apt-get install lamp-server^
    - enter password for mysql root user.

Create temp folder
*********************
mkdir temp
    - CD into folder (/user/temp)

Add Zabbix repo
*********************
sudo wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb
sudo dpkg -i zabbix-release_3.2-1+xenial_all.deb
sudo apt-get update

Install Zabbix Server
*********************
sudo apt-get install zabbix-server-mysql zabbix-frontend-php

Create database for Zabbix server
*********************
mysql -u root -p
CREATE DATABASE zabbixdb;
GRANT ALL on zabbixdb.* to zabbix@localhost IDENTIFIED BY 'ditt passord';
FLUSH PRIVILEGES;
exit

Restart Zabbix database schema in the new database
*********************
cd /usr/share/doc/zabbix-server-mysql/
sudo zcat create.sql.gz | mysql -u root -p zabbixdb

-- OBS -- this may take a while! -- OBS --

Edit Zabbix Config
*********************
sudo nano /etc/zabbix/zabbix_server.conf
    Update with the following (put it in the end of the file):

    DBHost=localhost
    DBName=zabbixdb
    DBUser=zabbix
    DBPassword=your mysql server password

ctrl + O to save
ctrl + X to quit

Restart services
*********************
sudo service apache2 restart
sudo service zabbix-server restart

Start Zabbix webconsole
*********************
Open a browser, navigate to: http://<servernavn/IP>/zabbix
Press Next Step

You may see some errors. if you do, do the following: 

Change Zabbix config
*********************
sudo nano /etc/php/7.0/apache2/php.ini

In nano, press ctrl + w

Type: date.timezone to jump to the right line.
Uncomment the line by removing ; and type: timezone = Europe/Oslo

ctrl + O to save
ctrl + X to quit 

Install missing PHP Extentions
*********************
sudo apt-get install php7.0-xml php7.0-bcmath php7.0-mbstring

Restart Zabbix Server
*********************
sudo service apache2 restart
sudo service zabbix-server restart

Log on Zabbix Server
*********************
Open a browser, navigate to: http://<servernavn/IP>/zabbix
Press Next Step

The Errors should now be gone.

Press Next Step
Enter database Info

Database Type: mysql
Database host: localhost
Database port: 0
database name: zabbixdb
User: zabbix
Password: ditt passord

Next Step

Zabbix Server Details

Host: localhost
Port: 10051 (this is default)
Name: ZabbixMonitoringServer (not necsasary)

Next next next, Finish

Login Info:
Brukernavn: admin
passord: zabbix