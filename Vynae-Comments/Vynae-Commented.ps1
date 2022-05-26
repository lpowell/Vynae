# pidhunter expanded and updated for modern systems, now called Vynae
# Goal is to cleanup the display of information and provide additional options for execution and data pull

# Main function, runs given no parameters
# parameters for the cli
param($Id, $Name, [switch]$Trace, [switch]$NetOnly, [switch]$help)
# defaults to this if no parameters are added
function PidHunt{
    # checks if it should only display processes with network connections
    if($NetOnly){
        # every process
        foreach($x in (get-ciminstance win32_process)){  
            # create the matching networking info
            $NetInfo = (get-nettcpconnection | ? OwningProcess -eq $x.ProcessId) 
            # checks to see if it has network connections
            if($NetInfo){
                # writes the info to the console
                Write-Host "<-----Process Information----->" -ForegroundColor green 
                Write-Host "Process Name: " -NoNewLine
                Write-Host $x.ProcessName -ForegroundColor green
                Write-Host "Process ID: " -NoNewLine
                Write-Host $x.ProcessId -ForegroundColor green
                Write-Host "Process PPID: " -NoNewLine
                Write-Host $x.ParentProcessID -ForegroundColor green
                Write-Host "Creation Date:" $x.CreationDate
                Write-Host "CSName:" $x.CSName
                # checks if properties have values
                if($x.ExecutablePath){
                   Write-Host "Executable Path:" $x.ExecutablePath 
                }
                if($x.CommandLine){
                    Write-Host "Command Line:" $x.CommandLine
                }
                Write-Host
                # checks if the LocalAddress property exists
                if($NetInfo.LocalAddress){
                    Write-Host "<-----Net Information----->" -ForegroundColor green
                    # for each connection
                    foreach($x in $NetInfo){
                        Write-Host "State: " -NoNewLine
                        Write-Host $x.State -ForegroundColor green
                        # formatting and styling for returned addresses
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
    # same as above but runs everything
    foreach($x in (get-ciminstance win32_process)){  
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

# Function given id 
function PidSnif($ID){
    # same as default but pulls process by ID
    foreach($x in (get-ciminstance win32_process | ? ProcessId -eq $ID)){  
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

# Function given Name
function PidName($Name){
    # Same as default pulling process by name
    if($NetOnly){
        foreach($x in (get-ciminstance win32_process | ? Name -match $Name)){  
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
        foreach($x in (get-ciminstance win32_process | ? Name -match $Name)){  
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
# Trace PPID
function PidTrace($Flag){
    # check if flag is an ID or name
    if($Flag -is [int]){
        # Only pull process info -- might add network later
        foreach($x in get-ciminstance win32_process | ? ProcessID -eq $Flag){
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
            # check if the next PPID still exists, and stops it at 0 to prevent looping
            if((get-ciminstance win32_process | ? ProcessId -eq $x.ParentProcessID) -And [int]$x.ProcessId -ne 0){
                PidTrace([int]$x.ParentProcessID)
            }else{
                Write-Host "<--Process cannot Be traced further-->" -ForegroundColor red
            }
        }
    }else{
        # If flag is name
        foreach($x in get-ciminstance win32_process | ? ProcessName -match $Flag){
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
            if((get-ciminstance win32_process | ? ProcessId -eq $x.ParentProcessID) -And [int]$x.ProcessId -ne 0){
                PidTrace([int]$x.ParentProcessID)
            }else{
                Write-Host "<--Process cannot Be traced further-->" -ForegroundColor red
            }
        }
    }
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
    Write-Host "    -Name" -ForegroundColor green -NoNewLine
    Write-Host " Used to pull information on ALL processes whose names match the value"
    Write-Host
    Write-Host "    -Trace" -ForegroundColor green -NoNewLine
    Write-Host " Used to trace a process' ParentProcessID back to the originating process"
    Write-Host "            Must specify a -Name or -ID"
    Write-Host
    Write-Host "    -NetOnly" -ForegroundColor green -NoNewLine
    Write-Host " Used to only pull processes with matching nettcpconnections"
    Write-Host "            Can only be used with -Name or defaults"
    Write-Host
    Write-Host "Running with no parameters will scan all processes and list process information and network information"
    Write-Host
    exit
}
if($Trace){
    if($ID){
        PidTrace($ID)        
    }elseif($Name){
        PidTrace($Name)
    }else{
        Write-Host -ForegroundColor red "ERROR"
        Write-Host "Specify an ID or Name"
    }
}elseif($ID){
    PidSnif($ID)
}elseif($Name){
    PidName($Name)
}else{
    PidHunt
}