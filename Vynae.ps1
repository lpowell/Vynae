# pidhunter expanded and updated for modern systems, now called Vynae
# Goal is to cleanup the display of information and provide additional options for execution and data pull

# Main function, runs given no parameters
param($Id, $Name, [switch]$Trace, [switch]$NetOnly, [switch]$help, $PPID, $NetStatus, $output, [switch]$hash)
function PidHunt{
    if($NetOnly){
        foreach($x in (get-ciminstance CIM_Process)){  
            $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId) 
            if($NetInfo){
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
                if($NetInfo.LocalAddress){
                    Write-Host "<-----Net Information----->" -ForegroundColor green
                    foreach($x in $NetInfo){
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
        }
    }else{
        if($NetStatus){
            foreach($x in (get-ciminstance CIM_Process)){  
                $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId | ? State -eq $NetStatus) 
                if($NetInfo){
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
                    if($NetInfo.LocalAddress){
                        Write-Host "<-----Net Information----->" -ForegroundColor green
                        foreach($x in $NetInfo){
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
            }
        }else{
            foreach($x in (get-ciminstance CIM_Process)){  
                $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId) 
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
                if($NetInfo.LocalAddress){
                    Write-Host "<-----Net Information----->" -ForegroundColor green
                    foreach($x in $NetInfo){
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
        }
    }  
    try{
        $ErrorActionPreference="SilentlyContinue"
        Stop-Transcript | out-null
        $ErrorActionPreference="Continue"
        }catch{}
}

# Function given id
function PidSnif($ID){
    foreach($x in (get-ciminstance CIM_Process | ? ProcessId -eq $ID)){  
        $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId) 
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
        if($NetInfo.LocalAddress){
            Write-Host "<-----Net Information----->" -ForegroundColor green
            foreach($x in $NetInfo){
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
    try{
        $ErrorActionPreference="SilentlyContinue"
        Stop-Transcript | out-null
        $ErrorActionPreference="Continue"
        }catch{}
}

# Function given Name
function PidName($Name){
    if($NetOnly){
        foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){  
            $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId)
            if($NetInfo){
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
                    if($NetInfo.LocalAddress){
                        Write-Host "<-----Net Information----->" -ForegroundColor green
                        foreach($x in $NetInfo){
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
        }
    }else{
        if($NetStatus){
            foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){
                $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId | ? State -eq $NetStatus) 
                if($NetInfo){
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
                    if($NetInfo.LocalAddress){
                        Write-Host "<-----Net Information----->" -ForegroundColor green
                        foreach($x in $NetInfo){
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
            }
        }else{
            foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){  
                $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId) 
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
                if($NetInfo.LocalAddress){
                    Write-Host "<-----Net Information----->" -ForegroundColor green
                    foreach($x in $NetInfo){
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
        }
    }
    try{
        $ErrorActionPreference="SilentlyContinue"
        Stop-Transcript | out-null
        $ErrorActionPreference="Continue"
        }catch{}
}
# Trace PPID || Add NetOnly and NetStatus?
function PidTrace($Flag){
    if($Flag -is [int]){
        foreach($x in get-ciminstance CIM_Process | ? ProcessID -eq $Flag){
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
            if((get-ciminstance CIM_Process | ? ProcessId -eq $x.ParentProcessID) -And [int]$x.ProcessId -ne 0){
                PidTrace([int]$x.ParentProcessID)
            }else{
                Write-Host "<--Process cannot Be traced further-->" -ForegroundColor red
            }
        }
    }else{
        foreach($x in get-ciminstance CIM_Process | ? ProcessName -match $Flag){
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
            if((get-ciminstance CIM_Process | ? ProcessId -eq $x.ParentProcessID) -And [int]$x.ProcessId -ne 0){
                PidTrace([int]$x.ParentProcessID)
            }else{
                Write-Host "<--Process cannot Be traced further-->" -ForegroundColor red
            }
        }
    }
    try{
        $ErrorActionPreference="SilentlyContinue"
        Stop-Transcript | out-null
        $ErrorActionPreference="Continue"
        }catch{}
}

# Search by PPID
function PidSpawn($PPID){
    if($NetOnly){
        foreach($x in (get-ciminstance CIM_Process | ? ParentProcessID -eq $PPID)){  
            $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId) 
            if($NetInfo){
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
                if($NetInfo.LocalAddress){
                    Write-Host "<-----Net Information----->" -ForegroundColor green
                    foreach($x in $NetInfo){
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
        }
    }else{
        if($NetStatus){
            foreach($x in (get-ciminstance CIM_Process | ? ParentProcessID -eq $PPID)){  
                $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId | ? State -eq $NetStatus)
                if($NetInfo){
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
                    if($NetInfo.LocalAddress){
                        Write-Host "<-----Net Information----->" -ForegroundColor green
                        foreach($x in $NetInfo){
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
            } 
        }else{
            foreach($x in (get-ciminstance CIM_Process | ? ParentProcessID -eq $PPID)){  
                $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId) 
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
                if($NetInfo.LocalAddress){
                    Write-Host "<-----Net Information----->" -ForegroundColor green
                    foreach($x in $NetInfo){
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
        }
    }
    try{
        $ErrorActionPreference="SilentlyContinue"
        Stop-Transcript | out-null
        $ErrorActionPreference="Continue"
        }catch{}
}

# File hash the process executable path and compare to known-bad files
# Add -ID & -Name
function PidHash($hash){
    Write-Host "<----- Loading Hashes ----->" -ForegroundColor green
    $HashList = Get-Content Hashes.txt
    if($Name){
        $GetProcess = get-ciminstance CIM_Process | ? Name -match $Name
    }elseif($ID){
        $GetProcess = get-ciminstance CIM_Process | ? ProcessId -eq $ID
    }else{
        $GetProcess = get-ciminstance CIM_Process
    }
    foreach($x in $GetProcess){   
        if($x.ExecutablePath){
            $ProcessHash = Get-FileHash $x.ExecutablePath
            $FoundHash = $False
            foreach($h in $HashList){
                if($ProcessHash.Hash -eq $h){
                    $FoundHash = $True
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
                    $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId)
                    if($NetInfo.LocalAddress){
                        Write-Host "<-----Net Information----->" -ForegroundColor green
                        foreach($x in $NetInfo){
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
            }
            if($FoundHash -eq $false){
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
                if($NetInfo.LocalAddress){
                    Write-Host "<-----Net Information----->" -ForegroundColor green
                    foreach($x in $NetInfo){
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
        }else{
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
            if($NetInfo.LocalAddress){
                Write-Host "<-----Net Information----->" -ForegroundColor green
                foreach($x in $NetInfo){
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
    }
    try{
        $ErrorActionPreference="SilentlyContinue"
        Stop-Transcript | out-null
        $ErrorActionPreference="Continue"
        }catch{}
}


# Redirect console stream to file
function PidOut($output){
    $ErrorActionPreference="SilentlyContinue"
    Stop-Transcript | out-null
    $ErrorActionPreference="Continue"
    Start-Transcript -path $output -append
}


if($output){
    PidOut($output)
}
if($help){
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
    Write-Host " Used to list all processes spwaned by the given PPID"
    Write-Host
    Write-Host "    -Name" -ForegroundColor green -NoNewLine
    Write-Host " Used to pull information on ALL processes whose names match the value"
    Write-Host
    Write-Host "    -Trace" -ForegroundColor green -NoNewLine
    Write-Host " Used to trace a process' ParentProcessID back to the originating process"
    Write-Host "            Must specify a -Name or -ID"
    Write-Host
    Write-Host "    -NetOnly" -ForegroundColor green -NoNewLine
    Write-Host " Used to only pull processes with matching nettcpconnections"
    Write-Host "            Can only be used with -Name, -PPID, or defaults"
    Write-Host
    Write-Host "    -NetStatus" -ForegroundColor green -NoNewLine
    Write-Host " Used to only pull processes with matching connection states"
    Write-Host "            Can be used with -Name, -PPID, and defaults"
    Write-Host
    Write-Host "    -Output" -ForegroundColor green -NoNewLine
    Write-Host " Specifies the output path for the PowerShell transcript of the session"
    Write-Host
    Write-Host "    -Hash" -ForegroundColor green -NoNewLine
    Write-Host " Hashes each process executable and compares it to the list Hashes.txt"
    Write-Host "            Alerts on matched hashes and processes without executable paths"
    Write-Host "            Can be used with -ID and -Name" 
    Write-Host
    Write-Host "    -Help" -ForegroundColor green -NoNewLine
    Write-Host " Displays this menu"
    Write-Host
    Write-Host "Running with no parameters will scan all processes and list process information and network information"
    Write-Host
    exit
}
# Add netonly to trace?
# To add -NetStatus -Output -Readable
if($Hash){
    PidHash
    exit
}
if($Trace){
    if($ID){
        try{
            if([int]$ID){
                PidTrace($ID)
            }
        }catch{
            Write-Host -ForegroundColor red "ERROR"
            Write-Host "ID must be an integer"
        }       
    }elseif($Name){
        PidTrace($Name)
    }else{
        Write-Host -ForegroundColor red "ERROR"
        Write-Host "Specify an ID or Name"
    }
}elseif($ID){
    try{
        if([int]$ID){
            PidSnif($ID)
        }
    }catch{
        Write-Host -ForegroundColor red "ERROR"
        Write-Host "ID must be an integer"
    }
}elseif($Name){
    PidName($Name)
}elseif($PPID){
    try{
        if([int]$PPID){
            PidSpawn($PPID)
        }
    }catch{
        Write-Host -ForegroundColor red "ERROR"
        Write-Host "PPID must be an integer"
    }
}else{
    PidHunt
}
