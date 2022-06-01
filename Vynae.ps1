param($ID, $Name, [switch]$Hash, [switch]$Trace, [switch]$NetOnly, [switch]$help, [switch]$AlertOnly, [switch]$NoPath, [switch]$Service, [switch]$NetSupress, $ServiceState, $ParentID, $NetStatus, $Output)
# Parameters accepted

# Function names 
# PidHunt -> ProcessInformation
# also handles PidSnif and PidName
# 
# all the write-host net info is now in it's own function that accepts proc names
# ErrorProcessing is for setting error states off
# 
# Design goals
# 1. Everything should be function based
# 2. Functions should be easy to understand
# Parameters as flags, e.g. if(NetOnly)

function ErrorProcessing{
    $ErrorActionPreference="SilentlyContinue"
}

# if name elif id else default && use params for name and id
function ProcessInformation(){
    if($Name){
        if($NetOnly -or $NetStatus){
            foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){
                $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID 
                if($TestNetConnection){
                    Write-Host "<-----Process Information----->" -ForegroundColor green 
                    Write-Host "Process Name: " -NoNewLine
                    Write-Host $x.ProcessName -ForegroundColor green
                    Write-Host "Process ID: " -NoNewLine
                    Write-Host $x.ProcessId -ForegroundColor green
                    Write-Host "Process PPID: " -NoNewLine
                    Write-Host $x.ParentProcessID -ForegroundColor green
                    Write-Host "Creation Date:" $x.CreationDate
                    Write-Host "CSName:" $x.CSName
                    if($x.ExecutablePath){
                       Write-Host "Executable Path:" $x.ExecutablePath 
                    }
                    if($x.CommandLine){
                        Write-Host "Command Line:" $x.CommandLine
                    }
                    Write-Host
                    NetworkInformation($x.ProcessID)
                }
            }
            }else{
                foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){
                    Write-Host "<-----Process Information----->" -ForegroundColor green 
                    Write-Host "Process Name: " -NoNewLine
                    Write-Host $x.ProcessName -ForegroundColor green
                    Write-Host "Process ID: " -NoNewLine
                    Write-Host $x.ProcessId -ForegroundColor green
                    Write-Host "Process PPID: " -NoNewLine
                    Write-Host $x.ParentProcessID -ForegroundColor green
                    Write-Host "Creation Date:" $x.CreationDate
                    Write-Host "CSName:" $x.CSName
                    if($x.ExecutablePath){
                       Write-Host "Executable Path:" $x.ExecutablePath 
                    }
                    if($x.CommandLine){
                        Write-Host "Command Line:" $x.CommandLine
                    }
                    Write-Host
                    NetworkInformation($x.ProcessID)
                }
            }
        }elseif($ID){
            foreach($x in (get-ciminstance CIM_Process | ? ProcessID -eq $ID)){
                Write-Host "<-----Process Information----->" -ForegroundColor green 
                Write-Host "Process Name: " -NoNewLine
                Write-Host $x.ProcessName -ForegroundColor green
                Write-Host "Process ID: " -NoNewLine
                Write-Host $x.ProcessId -ForegroundColor green
                Write-Host "Process PPID: " -NoNewLine
                Write-Host $x.ParentProcessID -ForegroundColor green
                Write-Host "Creation Date:" $x.CreationDate
                Write-Host "CSName:" $x.CSName
                if($x.ExecutablePath){
                   Write-Host "Executable Path:" $x.ExecutablePath 
                }
                if($x.CommandLine){
                    Write-Host "Command Line:" $x.CommandLine
                }
                Write-Host
                NetworkInformation($x.ProcessID)
            }
            }elseif($ParentID){
                if($NetOnly -or $NetStatus){
                    foreach($x in (get-ciminstance CIM_Process | ? ParentProcessID -eq $ParentID)){
                        try{
                            $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID | ? State -eq $NetStatus
                            }catch{
                                $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID 
                            }
                        if($TestNetConnection){
                            Write-Host "<-----Process Information----->" -ForegroundColor green 
                            Write-Host "Process Name: " -NoNewLine
                            Write-Host $x.ProcessName -ForegroundColor green
                            Write-Host "Process ID: " -NoNewLine
                            Write-Host $x.ProcessId -ForegroundColor green
                            Write-Host "Process PPID: " -NoNewLine
                            Write-Host $x.ParentProcessID -ForegroundColor green
                            Write-Host "Creation Date:" $x.CreationDate
                            Write-Host "CSName:" $x.CSName
                            if($x.ExecutablePath){
                               Write-Host "Executable Path:" $x.ExecutablePath 
                            }
                            if($x.CommandLine){
                                Write-Host "Command Line:" $x.CommandLine
                            }
                            Write-Host
                            NetworkInformation($x.ProcessID)
                        }
                    }
                    }else{
                        foreach($x in (get-ciminstance CIM_Process | ? ParentProcessID -eq $ParentID)){
                            Write-Host "<-----Process Information----->" -ForegroundColor green 
                            Write-Host "Process Name: " -NoNewLine
                            Write-Host $x.ProcessName -ForegroundColor green
                            Write-Host "Process ID: " -NoNewLine
                            Write-Host $x.ProcessId -ForegroundColor green
                            Write-Host "Process PPID: " -NoNewLine
                            Write-Host $x.ParentProcessID -ForegroundColor green
                            Write-Host "Creation Date:" $x.CreationDate
                            Write-Host "CSName:" $x.CSName
                            if($x.ExecutablePath){
                               Write-Host "Executable Path:" $x.ExecutablePath 
                            }
                            if($x.CommandLine){
                                Write-Host "Command Line:" $x.CommandLine
                            }
                            Write-Host
                            NetworkInformation($x.ProcessID)
                        }
                    }
                }else{
                if($NetOnly -or $NetStatus){
                    foreach($x in (get-ciminstance CIM_Process)){
                        try{
                            $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID | ? State -eq $NetStatus
                            }catch{
                                $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID 
                            }
                        if($TestNetConnection){
                            Write-Host "<-----Process Information----->" -ForegroundColor green 
                            Write-Host "Process Name: " -NoNewLine
                            Write-Host $x.ProcessName -ForegroundColor green
                            Write-Host "Process ID: " -NoNewLine
                            Write-Host $x.ProcessId -ForegroundColor green
                            Write-Host "Process PPID: " -NoNewLine
                            Write-Host $x.ParentProcessID -ForegroundColor green
                            Write-Host "Creation Date:" $x.CreationDate
                            Write-Host "CSName:" $x.CSName
                            if($x.ExecutablePath){
                               Write-Host "Executable Path:" $x.ExecutablePath 
                            }
                            if($x.CommandLine){
                                Write-Host "Command Line:" $x.CommandLine
                            }
                            Write-Host
                            NetworkInformation($x.ProcessID)
                        }
                    }
                    }else{
                        foreach($x in (get-ciminstance CIM_Process)){
                            Write-Host "<-----Process Information----->" -ForegroundColor green 
                            Write-Host "Process Name: " -NoNewLine
                            Write-Host $x.ProcessName -ForegroundColor green
                            Write-Host "Process ID: " -NoNewLine
                            Write-Host $x.ProcessId -ForegroundColor green
                            Write-Host "Process PPID: " -NoNewLine
                            Write-Host $x.ParentProcessID -ForegroundColor green
                            Write-Host "Creation Date:" $x.CreationDate
                            Write-Host "CSName:" $x.CSName
                            if($x.ExecutablePath){
                               Write-Host "Executable Path:" $x.ExecutablePath 
                            }
                            if($x.CommandLine){
                                Write-Host "Command Line:" $x.CommandLine
                            }
                            Write-Host
                            NetworkInformation($x.ProcessID)
                        }
                    }   
            }
}

function NetworkInformation($ProcessID){
    if(get-nettcpconnection | ? OwningProcess -eq $ProcessID | ? State -eq $NetStatus -And -Not $NetSupress){
        Write-Host "<-----Net Information----->" -ForegroundColor green
        foreach($x in (get-nettcpconnection | ? OwningProcess -eq $ProcessID | ? State -eq $NetStatus)){
            Write-Host "State: " -NoNewLine
            Write-Host $x.State -ForegroundColor green
            if($x.LocalAddress | Select-String -Pattern "::"){
                if($x.LocalAddress -eq '::'){
                    Write-Host "Local IPv6 Address/Port:" -NoNewLine
                    Write-Host "any" -ForegroundColor red -NoNewLine
                    Write-Host ":" $x.LocalPort
                }else{
                    Write-Host "Local IPv6 Address/Port: " $x.LocalAddress ":" $x.LocalPort   
                }
                if($x.RemoteAddress -eq '::'){
                    Write-Host "Remote IPv6 Address/Port:" -NoNewLine
                    Write-Host "any" -ForegroundColor red -NoNewLine
                    Write-Host ":" $x.RemotePort
                }else{
                    Write-Host "Remote IPv6 Address/Port:" $x.RemoteAddress ":" $x.RemotePort
                }
            }else{
                if($x.LocalAddress -eq '0.0.0.0'){
                    Write-Host "Local IPv4 Address/Port:" -NoNewLine
                    Write-Host "any" -ForegroundColor red -NoNewLine
                    Write-Host ":" $x.LocalPort
                }else{
                    Write-Host "Local IPv4 Address/Port:" $x.LocalAddress ":" $x.LocalPort
                }
                if($x.RemoteAddress -eq '0.0.0.0'){
                    Write-Host "Remote IPv4 Address/Port:" -NoNewLine
                    Write-Host "any" -ForegroundColor red -NoNewLine
                    Write-Host ":" $x.RemotePort
                }else{
                    Write-Host "Remote IPv4 Address/Port:" $x.RemoteAddress ":" $x.RemotePort
                }
            }
            Write-Host
        }  
        }elseif(get-nettcpconnection | ? OwningProcess -eq $ProcessID -And -Not $NetSupress){
            Write-Host "<-----Net Information----->" -ForegroundColor green
            foreach($x in (get-nettcpconnection | ? OwningProcess -eq $ProcessID)){
                Write-Host "State: " -NoNewLine
                Write-Host $x.State -ForegroundColor green
                if($x.LocalAddress | Select-String -Pattern "::"){
                    if($x.LocalAddress -eq '::'){
                        Write-Host "Local IPv6 Address/Port:" -NoNewLine
                        Write-Host "any" -ForegroundColor red -NoNewLine
                        Write-Host ":" $x.LocalPort
                    }else{
                        Write-Host "Local IPv6 Address/Port: " $x.LocalAddress ":" $x.LocalPort   
                    }
                    if($x.RemoteAddress -eq '::'){
                        Write-Host "Remote IPv6 Address/Port:" -NoNewLine
                        Write-Host "any" -ForegroundColor red -NoNewLine
                        Write-Host ":" $x.RemotePort
                    }else{
                        Write-Host "Remote IPv6 Address/Port:" $x.RemoteAddress ":" $x.RemotePort
                    }
                }else{
                    if($x.LocalAddress -eq '0.0.0.0'){
                        Write-Host "Local IPv4 Address/Port:" -NoNewLine
                        Write-Host "any" -ForegroundColor red -NoNewLine
                        Write-Host ":" $x.LocalPort
                    }else{
                        Write-Host "Local IPv4 Address/Port:" $x.LocalAddress ":" $x.LocalPort
                    }
                    if($x.RemoteAddress -eq '0.0.0.0'){
                        Write-Host "Remote IPv4 Address/Port:" -NoNewLine
                        Write-Host "any" -ForegroundColor red -NoNewLine
                        Write-Host ":" $x.RemotePort
                    }else{
                        Write-Host "Remote IPv4 Address/Port:" $x.RemoteAddress ":" $x.RemotePort
                    }
                }
                Write-Host
            }  
        }

}

function ParentProcessTracing(){
    if($ID){
        foreach($x in get-ciminstance CIM_Process | ? ProcessID -eq $ID){
            Write-Host "<-----Process Information----->" -ForegroundColor green 
            Write-Host "Process Name: " -NoNewLine
            Write-Host $x.ProcessName -ForegroundColor green
            Write-Host "Process ID: " -NoNewLine
            Write-Host $x.ProcessId -ForegroundColor green
            Write-Host "Process PPID: " -NoNewLine
            Write-Host $x.ParentProcessID -ForegroundColor green
            Write-Host "Creation Date:" $x.CreationDate
            Write-Host "CSName:" $x.CSName
            if($x.ExecutablePath){
               Write-Host "Executable Path:" $x.ExecutablePath 
            }
            if($x.CommandLine){
                Write-Host "Command Line:" $x.CommandLine
            }
            Write-Host
            NetworkInformation($x.ProcessID)
            if((get-ciminstance CIM_Process | ? ProcessId -eq $x.ParentProcessID) -And [int]$x.ProcessId -ne 0){
                $ID = $x.ParentProcessID
                ParentProcessTracing($ID)
            }else{
                Write-Host "<--Process cannot Be traced further-->" -ForegroundColor red
            }
        }
    }elseif($Name){
        foreach($x in get-ciminstance CIM_Process | ? ProcessName -match $Name){
            Write-Host "<-----Process Information----->" -ForegroundColor green 
            Write-Host "Process Name: " -NoNewLine
            Write-Host $x.ProcessName -ForegroundColor green
            Write-Host "Process ID: " -NoNewLine
            Write-Host $x.ProcessId -ForegroundColor green
            Write-Host "Process PPID: " -NoNewLine
            Write-Host $x.ParentProcessID -ForegroundColor green
            Write-Host "Creation Date:" $x.CreationDate
            Write-Host "CSName:" $x.CSName
            if($x.ExecutablePath){
               Write-Host "Executable Path:" $x.ExecutablePath 
            }
            if($x.CommandLine){
                Write-Host "Command Line:" $x.CommandLine
            }
            Write-Host
            NetworkInformation($x.ProcessID)
            if((get-ciminstance CIM_Process | ? ProcessId -eq $x.ParentProcessID) -And [int]$x.ProcessId -ne 0){
                $ID = $x.ParentProcessID
                ParentProcessTracing($ID)
            }else{
                Write-Host "<--Process cannot Be traced further-->" -ForegroundColor red
            }
        }
    }
}

function ProcessHashing(){
    $HashedArray=@()
    Write-Host "<----- Loading Hashes ----->" -ForegroundColor green
    Try{
        $HashList = Get-Content Hashes.txt
        if($HashList -eq $null){
            throw
        }
        Write-Host
        Write-Host "<----- Hashes Successfully Loaded ----->" -ForegroundColor green
        }Catch{
            Write-Host "<----- Hashes not loaded! ----->" -ForegroundColor red
            exit
        }
    if($ID){
        $Process = get-ciminstance CIM_Process | ? ProcessID -eq $ID
        }elseif($Name){
            $Process = get-ciminstance CIM_Process | ? Name -match $Name
            }else{
                $Process = get-ciminstance CIM_Process 
            }
    foreach($x in $Process){ 
        $ProcessHash = Get-FileHash $x.ExecutablePath
        $FoundHash = $False
        if(-Not $HashedArray.contains($ProcessHash.hash)){
            if($x.ExecutablePath){
               foreach($h in $HashList){
                   if($ProcessHash.Hash -eq $h){
                       $FoundHash = $True
                   }
               } 
                $HashedArray += $ProcessHash.hash
                if($FoundHash -eq $false -And -Not $AlertOnly){
                    Write-Host "No matches found!" -ForegroundColor green
                    Write-Host "<-----Process Information----->" -ForegroundColor green 
                    Write-Host "Process Name: " -NoNewLine
                    Write-Host $x.ProcessName -ForegroundColor green
                    Write-Host "Process ID: " -NoNewLine
                    Write-Host $x.ProcessId -ForegroundColor green
                    Write-Host "Process PPID: " -NoNewLine
                    Write-Host $x.ParentProcessID -ForegroundColor green
                    Write-Host "Creation Date:" $x.CreationDate
                    Write-Host "CSName:" $x.CSName
                    if($x.ExecutablePath){
                       Write-Host "Executable Path:" $x.ExecutablePath 
                    }
                    if($x.CommandLine){
                        Write-Host "Command Line:" $x.CommandLine
                    }
                    Write-Host "Hash: " $ProcessHash.Hash
                    Write-Host
                }elseif($FoundHash -eq $True){
                    Write-Host "<-----Hash Comparison----->" -ForegroundColor green
                    Write-Host
                    Write-Host "Alert -- Found match!" -ForegroundColor red
                    Write-Host "Hash of " $x.ProcessName "with ID " $x.ProcessId "and ExecutablePath of " $x.ExecutablePath "matches hash " $h
                    Write-Host
                    Write-Host "<-----Process Information----->" -ForegroundColor green 
                    Write-Host "Process Name: " -NoNewLine
                    Write-Host $x.ProcessName -ForegroundColor green
                    Write-Host "Process ID: " -NoNewLine
                    Write-Host $x.ProcessId -ForegroundColor green
                    Write-Host "Process PPID: " -NoNewLine
                    Write-Host $x.ParentProcessID -ForegroundColor green
                    Write-Host "Creation Date:" $x.CreationDate
                    Write-Host "CSName:" $x.CSName
                    if($x.ExecutablePath){
                       Write-Host "Executable Path:" $x.ExecutablePath 
                    }
                    if($x.CommandLine){
                        Write-Host "Command Line:" $x.CommandLine
                    }
                    Write-Host "Hash: " $ProcessHash.Hash
                    Write-Host
                }
            }elseif(-Not $NoPath){
                Write-Host "Alert -- Could not find Path!" -ForegroundColor red
                Write-Host "Could not find Executable Path for " $x.ProcessName " with ID " $x.ProcessID
                Write-Host
                Write-Host "<-----Process Information----->" -ForegroundColor green 
                Write-Host "Process Name: " -NoNewLine
                Write-Host $x.ProcessName -ForegroundColor green
                Write-Host "Process ID: " -NoNewLine
                Write-Host $x.ProcessId -ForegroundColor green
                Write-Host "Process PPID: " -NoNewLine
                Write-Host $x.ParentProcessID -ForegroundColor green
                Write-Host "Creation Date:" $x.CreationDate
                Write-Host "CSName:" $x.CSName
                if($x.ExecutablePath){
                   Write-Host "Executable Path:" $x.ExecutablePath 
                }
                if($x.CommandLine){
                    Write-Host "Command Line:" $x.CommandLine
                }
                Write-Host
            }
        }  
    }
}

function ServiceInformation(){
    if($Name){
        try{
            $Services = get-ciminstance Win32_Service | ? Name -match $Name | ? State -eq $ServiceState
            }catch{
                $Services = get-ciminstance Win32_Service | ? Name -match $Name
            }
        foreach($x in $Services){
            $Process = get-ciminstance Win32_Process | ? ProcessID -eq $x.ProcessID
            Write-Host "<-----Service Information----->" -ForegroundColor green 
            Write-Host "Service Name: " -NoNewLine
            Write-Host $x.Name -ForegroundColor green
            Write-Host "Service Status: " -NoNewLine
            Write-Host $x.Status -ForegroundColor green
            Write-Host "Service State: " -NoNewLine
            Write-Host $x.State -ForegroundColor green
            Write-Host "Process ID: " -NoNewLine
            Write-Host $x.ProcessId -ForegroundColor green
            Write-Host "Process PPID: " -NoNewLine
            Write-Host $x.ParentProcessID -ForegroundColor green
            Write-Host "Creation Class:" $x.CreationClassName
            Write-Host "System Name:" $x.SystemName
            if($x.PathName){
               Write-Host "Executable Path:" $x.PathName 
            }
            if($x.InstallDate){
                Write-Host "Install Date:" $x.InstallDate
            }
            Write-Host "Description: " $x.Description
            Write-Host
            NetworkInformation($x.ProcessID)
        }
        }else{
            try{
                $Services = get-ciminstance Win32_Service | ? State -eq $ServiceState
                }catch{
                    $Services = get-ciminstance Win32_Service
                }
            foreach($x in $Services){
                $Process = get-ciminstance Win32_Process | ? ProcessID -eq $x.ProcessID
                Write-Host "<-----Service Information----->" -ForegroundColor green 
                Write-Host "Service Name: " -NoNewLine
                Write-Host $x.Name -ForegroundColor green
                Write-Host "Service Started: " -NoNewLine
                Write-Host $x.Started -ForegroundColor green
                Write-Host "Service Status: " -NoNewLine
                Write-Host $x.Status -ForegroundColor green
                Write-Host "Process ID: " -NoNewLine
                Write-Host $x.ProcessId -ForegroundColor green
                Write-Host "Process PPID: " -NoNewLine
                Write-Host $x.ParentProcessID -ForegroundColor green
                Write-Host "Creation Class:" $x.CreationClassName
                Write-Host "System Name:" $x.SystemName
                if($x.PathName){
                   Write-Host "Executable Path:" $x.PathName 
                }
                if($x.InstallDate){
                    Write-Host "Install Date:" $x.InstallDate
                }
                Write-Host "Description: " $x.Description
                Write-Host
                NetworkInformation($x.ProcessID)
            }
        }
}

function VynaeHelp($Action){
    Write-Host
    Write-Host "Vynae"
    Write-Host "A PowerShell tool for extracting process Information"
    Write-Host
    Write-Host "Usage"
    Write-Host
    Write-Host "    -ID" -ForegroundColor green -NoNewLine
    Write-Host " Used to pull information on a specific ProcessID"
    Write-Host
    Write-Host "    -PPID" -ForegroundColor green -NoNewLine
    Write-Host " Used to list all processes spawned by the given PPID"
    Write-Host
    Write-Host "    -Name" -ForegroundColor green -NoNewLine
    Write-Host " Used to pull information on ALL processes whose names match the value"
    Write-Host
    Write-Host "    -Trace" -ForegroundColor green -NoNewLine
    Write-Host " Used to trace a process ParentProcessID back to the originating process"
    Write-Host "            Must specify a -Name or -ID"
    Write-Host
    Write-Host "    -NetOnly" -ForegroundColor green -NoNewLine
    Write-Host " Used to only pull processes with network connections"
    Write-Host
    Write-Host "    -NetStatus" -ForegroundColor green -NoNewLine
    Write-Host " Used to only pull processes with matching network connection states"
    Write-Host
    Write-Host "    -NetSupress" -ForegroundColor green -NoNewLine
    Write-Host " Used to hide network information."
    Write-Host
    Write-Host "    -Service" -ForegroundColor green -NoNewLine
    Write-Host " Used to scan services instead of processes"
    Write-Host "            Use -ServiceState to filter by Running/Stopped"
    Write-Host
    Write-Host "    -Output" -ForegroundColor green -NoNewLine
    Write-Host " Specifies the output path for the PowerShell transcript of the session"
    Write-Host
    Write-Host "    -Hash" -ForegroundColor green -NoNewLine
    Write-Host " Hashes each process executable and compares it to the list Hashes.txt"
    Write-Host "            Alerts on matched hashes and processes without executable paths"
    Write-Host "            Hide No Path alerts with -NoPath, and hide No match found messages with -AlertOnly."
    Write-Host
    Write-Host "    -Help" -ForegroundColor green -NoNewLine
    Write-Host " Displays this menu"
    Write-Host
    Write-Host "Running with no parameters will scan all processes and list process information and network information"
    Write-Host
}
$ErrorActionPreference="SilentlyContinue"
if($Output){
    start-transcript -path $output -append
}
if($Service){
    ServiceInformation
}
if($Trace){
    ParentProcessTracing
}
if($Hash){
    ProcessHashing
}
if($Help){
    VynaeHelp
}
if(-Not $Trace -and -Not $Hash -And -Not $Help -And -Not $Service){
    ProcessInformation  
}
if($Output){
    stop-transcript
}