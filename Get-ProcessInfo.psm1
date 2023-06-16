#  %{$_.Days * 24 + $_.Hours":"$_.Minutes}
<#
ISSUES

* Track time to completion
* 


PARAM DEF

Name                Description                                             Done?
----------------------------------------------------------------------------------
Name                Name of the processes                                       Y
Strict              Force exact match for string options                        Y
Network             Return network information                                  Y
ID                  Process ID                                                  Y
PPID                Parent Process ID                                           Y
ParentName          Parent Process Name                                         Y
ExecutablePath      Process Executable Path                                     Y
CommandLine         Search command line options                                 Y
Visualize           Create a visualization of the data                          Y
Trace               Trace the process back to it's origin                       Y
Time                Specify a time Days/Hours/Minutes                           N
Hash                Search via hash                                             Y
Algorithm           Algorithm for hashing                                       Y
NetOnly             Only Show processes with network connections                Y
NetState            Search by network state                                     Y
Outfile             Save a transcript                                           Y
ManualQuery         User entered query (CQL)                                    Y
#>


<#GLOBALS#>
$global:ErrorActionPreference="SilentlyContinue"




<#Network Retrieval#>
function NetworkGather($Process){
    $x = Get-NetTCPConnection -OwningProcess $Process
    $NetworkInfo = [ordered]@{      
        State           = $x.State
        LocalAddress    = $x.LocalAddress
        LocalPort       = $x.LocalPort
        RemoteAddress   = $x.RemoteAddress
        RemotePort      = $x.RemotePort
    }
    return $NetworkInfo
}

<#BUILD CIM QUERY#>
function CIMQUERY{
    <#MANUAL USER QUERY#>
    if($ManualQuery){
        $global:QueryList += "`n`tGet-CimInstance -Query `"$ManualQuery`""
        return "Get-CimInstance -Query `"$ManualQuery`""
    }

    <# BUILD QUERY

    String properties must be enclosed in escaped single quotes `'string`'

    #>
    $expression = "Get-CimInstance -Query `"Select * from WIN32_Process"
    if($Name -or $ID -or $PPID -or $ExecutablePath -or $CommandLine){$expression += " where "}
    <#BUILD STANDARD QUERY#>
    if($Trace -eq $False){
        if($Name){
            # Test if other properties have been added
            if($expression.length -ne 58){
                $expression += " AND "
            }
            if($Strict){
                $expression += "name=`'$name`'"
            }else{
                $expression += "name like `'$name%`'"
            }
        }
        if($ID){
            if($expression.length -ne 58){
                $expression += " AND "
            }
            $expression += "ProcessId=$ID"
        }
        if($PPID){
            if($expression.length -ne 58){
                $expression += " AND "
            }
            $expression += "ParentProcessId=$PPID"
        }
        if($ExecutablePath){
            if($expression.length -ne 58){
                $expression += " AND "
            }
            if($Strict){
                $expression += "ExecutablePath=`'$ExecutablePath`'"
            }else{
                $expression += "ExecutablePath like `'%$ExecutablePath%`'"
            }
        }
        if($CommandLine){
            if($expression.length -ne 58){
                $expression += " AND "
            }
            if($Strict){
                $expression += "CommandLine=`'$CommandLine`'"
            }else{
                $expression += "CommandLine like `'%$CommandLine%`'"
            }
        }
        # End Query
        $expression += "`""

        <# START OPTIONS#>
        if($ParentName){
            $expression += " | % {if ((Get-Process -ID `$_.ParentProcessId).Name -match `$ParentName){`$_}}"
        }
        if($NetOnly){
            $expression += " | % {if ((Get-NetTCPConnection -OwningProcess `$_.ProcessId)){`$_}}"
        }
        if($NetState){
            $expression += " | % {if ((Get-NetTCPConnection -OwningProcess `$_.ProcessId) -and ((Get-NetTCPConnection -OwningProcess `$_.ProcessId).state -eq `$NetState)){`$_}}"
        }
        if($Hash){
            $expression += " | % {if ((Get-FileHash `$_.ExecutablePath -Algorithm `$Algorithm).hash -eq `"`$Hash`"){`$_}}"
        }
        $global:QueryList += "`n`t$expression"
        return $expression
    }
    <#BUILD TRACE QUERY#>
    if($Trace){
        $expression += "ProcessId=$ID"
        $expression += "`""
        $global:QueryList += "`n`t$expression"
        return $expression
    }
}


<#OUTPUT FILTERING#>
function ProcessOutput($Process){
    $Process
    if($Visualize){
        $global:ProcessArray += $Process
    }
    if($Network){
        Get-NetTCPConnection -OwningProcess $Process.ID | ft State,LocalAddress,LocalPort,RemoteAddress,RemotePort
    }
    if($Trace){
        $Parent = $Process.ParentId
        if((Get-CimInstance -Query "SELECT * FROM WIN32_Process WHERE ProcessId=$Parent") -And $Parent -ne 0 -And $Parent -ne $NULL){
            Get-ProcessInfo -Trace -ID $Process.ParentId
        }
    }
}


<#
.Synopsis
  Process examination and analysis tool.  

.Description
  Vynae 2.0 is a module focused version of Vynae and is designed for process exmaination and analysis. 
  Using custom PSObjects, Vynae 2.0 can be integrated into any script and can be used with built-in tools like select-object, where-object, and foreach-object. 
  This is an upgrade from the original Vynae tool, which did not take advantage of custom objects. 

  Vynae has many applications and uses, and further information can be found on https://blog.bajiri.com. 

.Parameter Name                
    Name of the processes                                       
.Parameter Strict              
    Force exact match for string options                        
.Parameter Network             
    Return network information                                  
.Parameter ID                  
    Process ID                                                  
.Parameter PPID                
    Parent Process ID                                           
.Parameter ParentName          
    Parent Process Name                                         
.Parameter ExecutablePath      
    Process Executable Path                                     
.Parameter CommandLine         
    Search command line options                                 
.Parameter Visualize           
    Create a visualization of the data (GridView)                         
.Parameter Trace               
    Trace the process back to its origin                       
.Parameter Hash                
    Search via hash                                             
.Parameter Algorithm           
    Algorithm for hashing                                       
.Parameter NetOnly             
    Only Show processes with network connections                
.Parameter NetState            
    Search by network state                                     
.Parameter Outfile             
    Save a transcript                                           
.Parameter ManualQuery         
    User entered query (CQL)                                    

.Example 
   # List all processes
   Get-ProcessInfo

.Example
   # List all processes and associated network connections.
   Get-ProcessInfo -Network

.Link
    http://blog.bajiri.com
   
#>
function Get-ProcessInfo{
    param([switch]$Network, [string]$Name, [switch]$Strict, [int]$ID, [int]$PPID, [string]$ParentName, [string]$ExecutablePath, [string]$CommandLine, [Switch]$Trace, [DateTime]$Time, [string]$Hash, [string]$Algorithm="SHA256", [Switch]$NetOnly, [string]$NetState, [string]$Outfile, [switch]$Visualize, [string]$ManualQuery)
    Begin {
        $Stopwatch = [System.Diagnostics.Stopwatch]::startNew()
        $global:QueryList=@()
        if($Visualize){
            $global:ProcessArray =@()
        }
        if($Outfile){
            Start-Transcript $Outfile
        }
    }
    process {
        foreach($x in (iex (CIMQUERY) )){
            $Parent = Get-CimInstance CIM_Process | ? ProcessID -eq $x.ParentProcessID
            $ProcessInfo = New-Object PSObject -Property $([ordered]@{
                Name            = $x.ProcessName
                ID              = $x.ProcessId
                CommandLine     = $x.CommandLine
                ExecutablePath  = if ($x.ExecutablePath) {$x.ExecutablePath} else {""}
                ExecutableHash  = if ($x.ExecutablePath) { (Get-FileHash $x.ExecutablePath -Algorithm $Algorithm).Hash } else {""}
                ParentName      = $Parent.ProcessName
                ParentID        = $Parent.ProcessId
                ParentPath      = if ($Parent.ExecutablePath) {$Parent.ExecutablePath} else {""}
                ParentHash      = if ($Parent.ExecutablePath) {(Get-FileHash $Parent.ExecutablePath -Algorithm $Algorithm).Hash} else {""}
                CreationDate    = $x.CreationDate
                ActiveTime      = (New-TimeSpan -Start $x.CreationDate -End $(Get-Date) | Select Days, Hours, Minutes)
                })
            <#SET DEFAULT PROPERTIES (HIDE NETWORK PROPERTIES)#>
            $ProcessInfo.PSObject.TypeNames.Insert(0,'ProcessInfo')
            $DefaultDisplaySet = "Name, ID, CommandLine, ExecutablePath, ExecutableHash, ParentName, ParentID, ParentPath, ParentHash, CreationDate, ActiveTime"
            $DefaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet',[string[]]$DefaultDisplaySet)
            Update-TypeData -TypeName ProcessInfo -DefaultDisplayPropertySet Name, ID, CommandLine, ExecutablePath, ExecutableHash, ParentName, ParentID, ParentPath, ParentHash, CreationDate, ActiveTime
            if ($Network) {if (Get-NetTCPConnection -OwningProcess $x.ProcessId) {$Network_HT = NetworkGather($x.ProcessId); Add-Member -InputObject $ProcessInfo -NotePropertyMembers $Network_HT}}
            ProcessOutput($ProcessInfo)
        }
    }
    end {
        $Stopwatch.Stop() 
        Write-Host "Time Elapsed(seconds):"$Stopwatch.Elapsed.TotalSeconds
        write-Host "Queries used: "$QueryList
        Stop-Transcript
        if($Visualize){
            $global:ProcessArray | sort -property ActiveTime -Descending| ogv -Title "ProcessInfo"
        }
    }

}

Export-ModuleMember -Function Get-ProcessInfo