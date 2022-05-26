# pidhunter expanded and updated for modern systems, now called Vynae
# Goal is to cleanup the display of information and provide additional options for execution and data pull

# Main function, runs given no parameters
param($Id, $Name)
function PidHunt{
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
        Write-Host "Executable Path:" $x.ExecutablePath
        Write-Host "Command Line:" $x.CommandLine
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
        Write-Host "Executable Path:" $x.ExecutablePath
        Write-Host "Command Line:" $x.CommandLine
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
        Write-Host "Executable Path:" $x.ExecutablePath
        Write-Host "Command Line:" $x.CommandLine
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

if($Name){
    PidName($Name)
}
elseif($ID){
    PidSnif($ID)
}else{
    PidHunt
}