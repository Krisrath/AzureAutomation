$Plan = "Free"
$Location = "EastUS2"
$Solutions = "Security", "Updates", "SQLAssessment", "AntiMalware", "AgentHealthAssessment", "ChangeTracking", "LogManagement", `
"SiteRecovery", "Backup", "NetworkMonitoring"
$ResourceRG = "OMS-TestAutomation"
$WorkspaceName = "OMSTest"
$WindowsEventLogs = "Application", "Operations Manager", "System"

try {
    Get-AzureRmResourceGroup -Name $ResourceRG -ErrorAction Stop
} catch {
    New-AzureRmResourceGroup -Name $ResourceRG -Location $Location
}
# Create the workspace
New-AzureRmOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -Sku $Plan -ResourceGroupName $ResourceRG
 
foreach ($solution in $Solutions) {
    Set-AzureRmOperationalInsightsIntelligencePack -ResourceGroupName $ResourceRG  -WorkspaceName $WorkspaceName -IntelligencePackName $solution -Enabled $true
}

#Instance description. For Example: LogicalDisk(*)\Disk Read Bytes/sec, Instance is: *
#########################################################
$InstanceNameAll = “*”
$InstanceNameTotal = '_Total'
 
#########################################################
#Objects of the Performance Counters
#########################################################
$ObjectCache = "Cache"
$ObjectLogicalDisk = "LogicalDisk"
$ObjectMemory = "Memory"
$ObjectNetworkAdapter = "Network Adapter"
$ObjectNetworkInterface = "Network Interface"
$ObjectPagingFile = "Paging File"
$ObjectProcess = "Process"
$ObjectProcessorInformation = "Processor Information"
$ObjectProcessor = "Processor"
 
$ObjectSQLAgentAlerts = "SQLAgent:Alerts"
$ObjectSQLAgentJobs = "SQLAgent:Jobs"
$ObjectSQLAgentStatistics = "SQLAgent:Statistics"
 
$ObjectSQLServerAccessMethods = "SQLServer:Access Methods"
$ObjectSQLServerExecStatistics = "SQLServer:Exec Statistics"
$ObjectSQLServerLocks = "SQLServer:Locks"
$ObjectSQLServerSQLErrors = "SQLServer:SQL Errors"
 
$ObjectSystem = "System"
 
#########################################################
#Counters of the Performance Objects
#########################################################
$CounterCache = “Copy Read Hits %”
 
$CounterLogicalDisk = 
     "% Free Space" `
    ,"Avg. Disk sec/Read" `
    ,"Avg. Disk sec/Transfer" `
    ,"Avg. Disk sec/Write" `
    ,"Current Disk Queue Length" `
    ,"Disk Read Bytes/sec" `
    ,"Disk Reads/sec" `
    ,"Disk Transfers/sec" `
    ,"Disk Writes/sec"
 
$CounterMemory = 
     "% Committed Bytes In Use" `
    ,"Available MBytes" `
    ,"Page Faults/sec" `
    ,"Pages Input/sec" `
    ,"Pages Output/sec" `
    ,"Pool Nonpaged Bytes"
 
$CounterNetworkAdapter = 
     "Bytes Received/sec" `
    ,"Bytes Sent/sec"
 
$CounterNetworkInterface = "Bytes Total/sec"
 
$CounterPagingFile = 
     "% Usage" `
    ,"% Usage Peak"
 
$CounterProcess = "% Processor Time"
 
$CounterProcessorInformation = 
     "% Interrupt Time" `
    ,"Interrupts/sec"
 
$CounterProcessor = "% Processor Time"
$CounterProcessorTotal = "% Processor Time"
 
$CounterSQLAgentAlerts = "Activated alerts"
$CounterSQLAgentJobs = "Failed jobs"
$CounterSQLAgentStatistics = "SQL Server restarted"
$CounterSQLServerAccessMethods = "Table Lock Escalations/sec"
$CounterSQLServerExecStatistics = "Distributed Query"
$CounterSQLServerLocks = "Number of Deadlocks/sec"
$CounterSQLServerSQLErrors = "Errors/sec"
 
$CounterSystem = "Processor Queue Length"
 
ForEach ( $WEvent in $WindowsEventLogs)
{
    New-AzureRmOperationalInsightsWindowsEventDataSource -ResourceGroupName $ResourceRG  `
        -WorkspaceName $WorkspaceName -EventLogName $WEvent -CollectErrors -CollectWarnings -Name "$Wevent Event Log"
}
 
# Windows Perf
 
function AddPerfCounters ($PerfObject, $PerfCounters, $Instance, $PerfNo)
{
    ForEach ($Counter in $PerfCounters)
    {
    $PerfNo ++
      New-AzureRmOperationalInsightsWindowsPerformanceCounterDataSource -ResourceGroupName $ResourceRG  -WorkspaceName $WorkspaceName `
         -ObjectName $PerfObject  -CounterName $Counter -IntervalSeconds 10 -Name "ElastaBytes Performance Counter $PerfNo" -InstanceName $Instance
  #Name parameter needs to be unique. Adding random unique number. Name is not being showed anywhere in the Front End
    }
}
AddPerfCounters -PerfObject $ObjectLogicalDisk -PerfCounter $CounterLogicalDisk -Instance $InstanceNameAll -PerfNo 0
AddPerfCounters -PerfObject $ObjectNetworkAdapter -PerfCounter $CounterNetworkAdapter -Instance $InstanceNameAll -PerfNo 20
AddPerfCounters -PerfObject $ObjectNetworkInterface -PerfCounter $CounterNetworkInterface -Instance $InstanceNameAll -PerfNo 30
AddPerfCounters -PerfObject $ObjectPagingFile -PerfCounter $CounterPagingFile -Instance $InstanceNameAll -PerfNo 40
AddPerfCounters -PerfObject $ObjectProcess -PerfCounter $CounterProcess -Instance $InstanceNameAll -PerfNo 50
AddPerfCounters -PerfObject $ObjectProcessorInformation -PerfCounter $CounterProcessorInformation -Instance $InstanceNameAll -PerfNo 60
AddPerfCounters -PerfObject $ObjectProcessor -PerfCounter $CounterProcessor -Instance $InstanceNameAll -PerfNo 70
AddPerfCounters -PerfObject $ObjectProcessor -PerfCounter $CounterProcessorTotal -Instance $InstanceNameTotal -PerfNo 80
AddPerfCounters -PerfObject $ObjectSQLAgentAlerts -PerfCounter $CounterSQLAgentAlerts -Instance $InstanceNameAll -PerfNo 90
AddPerfCounters -PerfObject $ObjectSQLAgentJobs -PerfCounter $CounterSQLAgentJobs -Instance $InstanceNameAll -PerfNo 100
AddPerfCounters -PerfObject $ObjectSQLAgentStatistics -PerfCounter $CounterSQLAgentStatistics -Instance $InstanceNameAll -PerfNo 110
AddPerfCounters -PerfObject $ObjectSQLServerAccessMethods -PerfCounter $CounterSQLServerAccessMethods -Instance $InstanceNameAll -PerfNo 120
AddPerfCounters -PerfObject $ObjectSQLServerExecStatistics -PerfCounter $CounterSQLServerExecStatistics -Instance $InstanceNameAll -PerfNo 130
AddPerfCounters -PerfObject $ObjectSQLServerLocks -PerfCounter $CounterSQLServerLocks -Instance $InstanceNameAll -PerfNo 140
AddPerfCounters -PerfObject $ObjectSQLServerSQLErrors -PerfCounter $CounterSQLServerSQLErrors -Instance $InstanceNameAll -PerfNo 150
AddPerfCounters -PerfObject $ObjectSystem -PerfCounter $CounterSystem -Instance $InstanceNameAll -PerfNo 160
AddPerfCounters -PerfObject $ObjectMemory -PerfCounter $CounterMemory -Instance $InstanceNameAll -PerfNo 170
AddPerfCounters -PerfObject $ObjectCache -PerfCounter $CounterCache -Instance $InstanceNameAll -PerfNo 180