DeployOMSWorkspaceandcounters.ps1 is the primary automation file. The others are chunks of code that 
were integrated into the primary script.

There are a selection of variables that will need to be tailored to your specific deployment:
$OMSPlan = "Free"
$AutomationPlan = "Free"
$Location = "EastUS"
$Solutions = "Security", "Updates", "SQLAssessment", "AntiMalware", "AgentHealthAssessment", "ChangeTracking", "LogManagement", `
"SiteRecovery", "Backup", "NetworkMonitoring"
$AzureRG = "OMS-TestAutomation"
$WorkspaceName = "AGI-OMSTestPSAD"
$WindowsEventLogs = "Application", "Operations Manager", "System"
$RecoveryServicesVaultName = "omsrecservvault"
The Dashboard variables must match dashboard templates available here: https://github.com/Krisrath/AzureAutomation/tree/master/OMSDeploymentAutomation/OMSDashboardTemplates
$Dashboard1 = "OperationsDashboard" 
$Dashboard2 = "SecurityDashboard"
$AAA = "AGI-TestAutoAcc"
$AALocation = "EastUS2"
