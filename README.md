# MsSqlServerAgentReplacementForSqlWatcher
Powershell script for executing monitoring tasks for SqlWatcher by ms task sheduler.
Replacement for sql server agent cause express dont have one :|  

SqlWatcher monitor server by making snapshots called by task from sql server agent

#tutorial
* Execute Create.Necessary.StoredProcedures.sql for your SQLWATCH database
* Create task in windows task sheduler to call AgentlessJobForExpress.ps1 every 5 min or so 

# Grafana
Note: for Grafana the user need execute right on some sps for some stuff
