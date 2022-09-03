# SqlWatcherTaskForExpress
Powershell script to work with SqlWatcher to monitor sql server
SqlWatcher monitor server by making snapshots called by task from sql server agent
Sql server express dont have sql server agent :|  
this script & windows task sheduler can replace that bad boii

#tutorial
* Execute Create.Necessary.StoredProcedures.sql for your SQLWATCH database
* Create task in windows task sheduler to call AgentlessJobForExpress.ps1 every 5 min or so 

# Grafana
Note: for Grafana the user need execute right on some sps for some stuff
