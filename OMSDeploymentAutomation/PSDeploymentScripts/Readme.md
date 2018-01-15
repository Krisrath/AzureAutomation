DeployOMSWorkspaceandcounters.ps1 is the primary automation file. The others are chunks of code that 
were integrated into the primary script.

There are a selection of variables that will need to be tailored to your specific deployment:

 1.$OMSPlan = "Free"
 
 2.$AutomationPlan = "Free"
 
 3.$Location = "EastUS"
 
 4.$Solutions = "Security", "Updates", "SQLAssessment", "AntiMalware", "AgentHealthAssessment", "ChangeTracking", "LogManagement",    "SiteRecovery", "Backup", "NetworkMonitoring"
 
 5.$AzureRG = "OMS-TestAutomation"
 
 6.$WorkspaceName = "AGI-OMSTestPSAD"
 
 7.$WindowsEventLogs = "Application", "Operations Manager", "System"
 
 8.$RecoveryServicesVaultName = "omsrecservvault"
 
 9.The Dashboard variables must match dashboard templates available here:    
   -[LINK]https://github.com/Krisrath/AzureAutomation/tree/master/OMSDeploymentAutomation/OMSDashboardTemplates
  
 10.$Dashboard1 = "OperationsDashboard" 
 
 11.$Dashboard2 = "SecurityDashboard"
 
 12.$AAA = "AGI-TestAutoAcc"
 
 13.$AALocation = "EastUS2"
