param($ID, $Name, [switch]$Hash, [switch]$Trace, [switch]$NetOnly, [switch]$help, [switch]$AlertOnly, [switch]$NoPath, [switch]$Service, [switch]$NetSupress, [switch]$Colorblind, $Time, $Date, $TimeActive, $ServiceState, $ParentID, $NetStatus, $Output, $Module, $Mode, [switch]$Default)
# Parameters accepted



function GlobalOptions(){
    $global:DateTime = get-date
    $global:Path =Get-location
    $global:ErrorActionPreference="SilentlyContinue"
    # $host.UI.RawUI.BackgroundColor = "Black"
    if($Colorblind){
        $global:GoodColor = 'cyan'
        $global:BadColor = 'magenta'
        }else{
            $global:GoodColor = 'green'
            $global:BadColor = 'red'
        }
}
# if name elif id else default && use params for name and id
function ProcessInformation(){
    if($Name){
        if($NetOnly -or $NetStatus){
            foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){
                try{
                    $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID | ? State -eq $NetStatus
                    if($NetStatus -eq $null){
                        throw
                    }
                    }catch{
                        $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID 
                    }
                if($TestNetConnection){
                    ProcessPrint($x)
                }
            }
            }else{
                foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){
                    ProcessPrint($x)
                }
            }
        }elseif($ID){
            foreach($x in (get-ciminstance CIM_Process | ? ProcessID -eq $ID)){
                ProcessPrint($x)
            }
            }elseif($ParentID){
                if($NetOnly -or $NetStatus){
                    foreach($x in (get-ciminstance CIM_Process | ? ParentProcessID -eq $ParentID)){
                        try{
                            $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID | ? State -eq $NetStatus
                            if($NetStatus -eq $null){
                                throw
                            }
                            }catch{
                                $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID 
                            }
                        if($TestNetConnection){
                            ProcessPrint($x)
                        }
                    }
                    }else{
                        foreach($x in (get-ciminstance CIM_Process | ? ParentProcessID -eq $ParentID)){
                            ProcessPrint($x)
                        }
                    }
                }else{
                if($NetOnly -or $NetStatus){
                    foreach($x in (get-ciminstance CIM_Process)){
                        try{
                            $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID | ? State -eq $NetStatus
                            if($NetStatus -eq $null){
                                throw
                            }
                            }catch{
                                $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID 
                            }
                        if($TestNetConnection){
                            ProcessPrint($x)
                        }
                    }
                    }else{
                        foreach($x in (get-ciminstance CIM_Process)){
                            ProcessPrint($x)
                        }
                    }   
            }
}

function ProcessPrint($Process){
    $ActiveTime = New-TimeSpan -Start $Process.CreationDate -End $DateTime
    if($Date -And $Process.CreationDate.Date  -notcontains $Date){
        return
    }
    if($Time -in 0..24 -And $Process.CreationDate.Hour -ne [int]$Time){
        return
    }
    if($TimeActive -in 0..24 -And $ActiveTime.Hours -ne [int]$TimeActive){
        return
    }
    $ParentPath = get-ciminstance CIM_Process | ? ProcessID -eq $Process.ParentProcessID 
    Write-Host "<-----Process Information----->" -ForegroundColor $GoodColor 
    Write-Host "Process Name: " -NoNewLine
    Write-Host $Process.ProcessName -ForegroundColor $GoodColor
    Write-Host "Process ID: " -NoNewLine
    Write-Host $Process.ProcessId -ForegroundColor $GoodColor
    Write-Host "PPID Name: " -NoNewLine
    Write-Host $ParentPath.Name -ForegroundColor $GoodColor
    Write-Host "Process PPID: " -NoNewLine
    Write-Host $Process.ParentProcessID -ForegroundColor $GoodColor
    if($ParentPath.ExecutablePath){
       Write-Host "PPID Path:" $ParentPath.ExecutablePath 
    } 
    if($Process.CreationDate){
        Write-Host "Creation Date:" $Process.CreationDate
        Write-Host "Active for: " $ActiveTime.Hours 'Hours' $ActiveTime.Minutes 'Minutes'
    }
    Write-Host "CSName:" $Process.CSName
    if($Process.ExecutablePath){
       Write-Host "Executable Path:" $Process.ExecutablePath 
    }
    if($Process.CommandLine){
        Write-Host "Command Line:" $Process.CommandLine
    }
    Write-Host
    NetworkInformation($Process.ProcessID)
}

function NetworkInformation($ProcessID){
    if($NetSupress){
        return
    }
    if(get-nettcpconnection | ? OwningProcess -eq $ProcessID | ? State -eq $NetStatus){
        Write-Host "<-----Net Information----->" -ForegroundColor $GoodColor
        foreach($x in (get-nettcpconnection | ? OwningProcess -eq $ProcessID | ? State -eq $NetStatus)){
            NetworkPrint($x)
        }  
        }elseif(get-nettcpconnection | ? OwningProcess -eq $ProcessID){
            Write-Host "<-----Net Information----->" -ForegroundColor $GoodColor
            foreach($x in (get-nettcpconnection | ? OwningProcess -eq $ProcessID)){
            NetworkPrint($x)  
        }
    }
}

function NetworkPrint($Conn){
    Write-Host "State: " -NoNewLine
    Write-Host $Conn.State -ForegroundColor $GoodColor
    if($Conn.LocalAddress | Select-String -Pattern "::"){
        if($Conn.LocalAddress -eq '::'){
            Write-Host "Local IPv6 Address/Port:" -NoNewLine
            Write-Host "any" -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.LocalPort
        }else{
            Write-Host "Local IPv6 Address/Port: " $Conn.LocalAddress ":" $Conn.LocalPort   
        }
        if($Conn.RemoteAddress -eq '::'){
            Write-Host "Remote IPv6 Address/Port:" -NoNewLine
            Write-Host "any" -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.RemotePort
        }else{
            Write-Host "Remote IPv6 Address/Port:" $Conn.RemoteAddress ":" $Conn.RemotePort
        }
    }else{
        if($Conn.LocalAddress -eq '0.0.0.0'){
            Write-Host "Local IPv4 Address/Port:" -NoNewLine
            Write-Host "any" -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.LocalPort
        }else{
            Write-Host "Local IPv4 Address/Port:" $Conn.LocalAddress ":" $Conn.LocalPort
        }
        if($Conn.RemoteAddress -eq '0.0.0.0'){
            Write-Host "Remote IPv4 Address/Port:" -NoNewLine
            Write-Host "any" -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.RemotePort
        }else{
            Write-Host "Remote IPv4 Address/Port:" $Conn.RemoteAddress ":" $Conn.RemotePort
        }
    }
    Write-Host
}

function ParentProcessTracing(){
    if($ID){
        foreach($x in get-ciminstance CIM_Process | ? ProcessID -eq $ID){
            ProcessPrint($x)
            ProcessTrace($x)
        }
    }elseif($Name){
        foreach($x in get-ciminstance CIM_Process | ? ProcessName -match $Name){
            ProcessPrint($x)
            ProcessTrace($x)
        }
    }
}

function ProcessTrace($Process){
    if((get-ciminstance CIM_Process | ? ProcessId -eq $Process.ParentProcessID) -And [int]$Process.ProcessId -ne 0){
        $ID = $Process.ParentProcessID
        ParentProcessTracing
    }else{
        Write-Host "<--Process cannot Be traced further-->" -ForegroundColor $BadColor
    }
}

function ProcessHashing(){
    $HashedArray=@()
    Write-Host "<----- Loading Hashes ----->" -ForegroundColor $GoodColor
    Try{
        $HashList = Get-Content Hashes.txt
        if($HashList -eq $null){
            throw
        }
        Write-Host
        Write-Host "<----- Hashes Successfully Loaded ----->" -ForegroundColor $GoodColor
        }Catch{
            Write-Host "<----- Hashes not loaded! ----->" -ForegroundColor $BadColor
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
                    Write-Host "No matches found!" -ForegroundColor $GoodColor
                    Write-Host "<-----Process Information----->" -ForegroundColor $GoodColor 
                    Write-Host "Process Name: " -NoNewLine
                    Write-Host $x.ProcessName -ForegroundColor $GoodColor
                    Write-Host "Process ID: " -NoNewLine
                    Write-Host $x.ProcessId -ForegroundColor $GoodColor
                    Write-Host "Process PPID: " -NoNewLine
                    Write-Host $x.ParentProcessID -ForegroundColor $GoodColor
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
                    Write-Host "<-----Hash Comparison----->" -ForegroundColor $GoodColor
                    Write-Host
                    Write-Host "Alert -- Found match!" -ForegroundColor $BadColor
                    Write-Host "Hash of " $x.ProcessName "with ID " $x.ProcessId "and ExecutablePath of " $x.ExecutablePath "matches hash " $h
                    Write-Host
                    Write-Host "<-----Process Information----->" -ForegroundColor $GoodColor 
                    Write-Host "Process Name: " -NoNewLine
                    Write-Host $x.ProcessName -ForegroundColor $GoodColor
                    Write-Host "Process ID: " -NoNewLine
                    Write-Host $x.ProcessId -ForegroundColor $GoodColor
                    Write-Host "Process PPID: " -NoNewLine
                    Write-Host $x.ParentProcessID -ForegroundColor $GoodColor
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
                Write-Host "Alert -- Could not find Path!" -ForegroundColor $BadColor
                Write-Host "Could not find Executable Path for " $x.ProcessName " with ID " $x.ProcessID
                Write-Host
                Write-Host "<-----Process Information----->" -ForegroundColor $GoodColor 
                Write-Host "Process Name: " -NoNewLine
                Write-Host $x.ProcessName -ForegroundColor $GoodColor
                Write-Host "Process ID: " -NoNewLine
                Write-Host $x.ProcessId -ForegroundColor $GoodColor
                Write-Host "Process PPID: " -NoNewLine
                Write-Host $x.ParentProcessID -ForegroundColor $GoodColor
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
        if($NetOnly -or $NetStatus){
            try{
                $Services = get-ciminstance Win32_Service | ? Name -match $Name | ? State -eq $ServiceState
                if($ServiceState -eq $null){
                    throw
                }
                }catch{
                    $Services = get-ciminstance Win32_Service | ? Name -match $Name
                }
            foreach($x in $Services){
                try{
                    $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $Services.ProcessID | ? State -eq $NetStatus
                    if($NetStatus -eq $null){
                        throw
                    }
                    }catch{
                        $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $Services.ProcessID
                    }
                if($TestNetConnection){
                    foreach($y in $x){
                        ServicePrint($x)
                        NetworkInformation($x.ProcessID)
                    }
                }
            }
        }else{
            try{
                $Services = get-ciminstance Win32_Service | ? Name -match $Name | ? State -eq $ServiceState
                if($ServiceState -eq $null){
                    throw
                }
                }catch{
                    $Services = get-ciminstance Win32_Service | ? Name -match $Name
                }
            foreach($x in $Services){
            ServicePrint($x)
            NetworkInformation($x.ProcessID)
            }
        }
    }else{
        if($NetOnly -or $NetStatus){
            try{
                $Services = get-ciminstance Win32_Service | ? State -eq $ServiceState
                if($ServiceState -eq $null){
                    throw
                }
                }catch{
                    $Services = get-ciminstance Win32_Service 
                }
            foreach($x in $Services){
                try{
                    $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID | ? State -eq $NetStatus
                    if($NetStatus -eq $null){
                        throw
                    }
                    }catch{
                        $TestNetConnection = get-nettcpconnection | ? OwningProcess -eq $x.ProcessID
                    }
                if($TestNetConnection){
                    foreach($y in $x){
                        ServicePrint($x)
                        NetworkInformation($x.ProcessID)
                    }
                }
            }
        }else{
            try{
                $Services = get-ciminstance Win32_Service | ? State -eq $ServiceState
                if($ServiceState -eq $null){
                    throw
                }
                }catch{
                    $Services = get-ciminstance Win32_Service
                }
            foreach($x in $Services){
                ServicePrint($x)
                NetworkInformation($x.ProcessID)
            }
        }
    }                   
}

function ServicePrint($Service){
    $Process = get-ciminstance Win32_Process | ? ProcessID -eq $Service.ProcessID
    Write-Host "<-----Service Information----->" -ForegroundColor $GoodColor 
    Write-Host "Service Name: " -NoNewLine
    Write-Host $Service.Name -ForegroundColor $GoodColor
    Write-Host "Service Status: " -NoNewLine
    Write-Host $Service.Status -ForegroundColor $GoodColor
    Write-Host "Service State: " -NoNewLine
    Write-Host $Service.State -ForegroundColor $GoodColor
    Write-Host "Process ID: " -NoNewLine
    Write-Host $Service.ProcessId -ForegroundColor $GoodColor
    Write-Host "Process PPID: " -NoNewLine
    Write-Host $Process.ParentProcessID -ForegroundColor $GoodColor
    Write-Host "Creation Class:" $Service.CreationClassName
    Write-Host "System Name:" $Service.SystemName
    if($Service.PathName){
       Write-Host "Executable Path:" $Service.PathName 
    }
    if($Service.InstallDate){
        Write-Host "Install Date:" $Service.InstallDate
    }
    Write-Host "Description: " $Service.Description
    Write-Host
}

function VynaeHelp(){
    Write-Host
    Write-Host "Vynae"
    Write-Host "A PowerShell tool for extracting process Information"
    Write-Host
    Write-Host "Usage"
    Write-Host
    Write-Host "    -Default" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Runs Vynae's process information gatherer"
    Write-Host "        Gathers Name, ID, PPID Name, PPID, PPID Path, Creation Date, Active Time"
    Write-Host "        CSName, Executable Path, and Command Line options"
    Write-Host 
    Write-Host "        Filter with ID, Name, ParentID, Time options, or Net options"
    Write-Host
    Write-Host "    -ID" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to pull information on a specific ProcessID"
    Write-Host
    Write-Host "    -ParentID" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to list all processes spawned by the given ParentID"
    Write-Host
    Write-Host "    -Name" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to pull information on ALL processes whose names match the value"
    Write-Host
    Write-Host "    -Trace" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to trace a process ParentProcessID back to the originating process"
    Write-Host "            Must specify a -Name or -ID"
    Write-Host
    Write-Host "    -Time -Date -TimeActive" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to filter by date [str], time [int 0-23], and time active(hours) [int 0-23]"
    Write-Host
    Write-Host "    -Colorblind" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Uses magenta and cyan colors to help alleviate colorblind issues"
    Write-Host
    Write-Host "    -NetOnly" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to only pull processes with network connections"
    Write-Host
    Write-Host "    -NetStatus" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to only pull processes with matching network connection states"
    Write-Host
    Write-Host "    -NetSupress" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to hide network information."
    Write-Host
    Write-Host "    -Service" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to scan services instead of processes"
    Write-Host "            Use -ServiceState to filter by Running/Stopped"
    Write-Host
    Write-Host "    -Output" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Specifies the output path for the PowerShell transcript of the session"
    Write-Host
    Write-Host "    -Hash" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Hashes each process executable and compares it to the list Hashes.txt"
    Write-Host "            Alerts on matched hashes and processes without executable paths"
    Write-Host "            Hide No Path alerts with -NoPath, and hide No match found messages with -AlertOnly."
    Write-Host
    Write-Host "    -Module" -ForegroundColor $GoodColor -NoNewLine
    Write-Host "            Runs modules in /Modules"
    Write-Host "                Unless specified, Modules run in either -Mode Task or -Mode Control"
    Write-Host "                -Mode Task will create the scheduled task associated with the module"
    Write-Host "                -Mode Control will manually run the module's function"
    Write-Host "            Integrity"
    Write-Host "                Creates a scheduled task that compares a control list of processes"
    Write-Host "                to the current running processes and reports the differences, if any."
    Write-Host "            RunKeys"
    Write-Host "                Checks registry keys and temp files for known malicious hashes"
    Write-Host "                Use -Mode to specify RegKey check or TempFiles check"
    Write-Host "                Alternatively, run without -Mode to scan both"
    Write-Host "            BlackWall"
    Write-Host "                Creates a scheduled task that auto-bans IP addresses associated with security event 4625"
    Write-Host "                Can be modified using BlackWall.xml"
    Write-Host
    Write-Host "    -Help" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Displays this menu"
    Write-Host
    Write-Host "Running with no parameters will scan all processes and list process information and network information"
    Write-Host
}
GlobalOptions
if($Module){
    if($Module -eq 'Integrity'){
        $Path = get-location
        $Path = $Path.Path
        & "$Path\Modules\VynaeIntegrityCheck.ps1" -Mode Control -Path $Path
    }elseif($Module -eq 'RunKeys'){
        $Path = get-location
        $Path =$Path.Path
        & "$Path\Modules\VynaeRegCheck.ps1" -Mode $Mode -Path $Path
    }elseif($Module -eq 'BlackWall'){
        & "$Path\Modules\VynaeBlackWall.ps1" -Mode $Mode
    }
    exit
}
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
if($Default){
    ProcessInformation  
}
if($Output){
    stop-transcript
}
if($PSBoundParameters.Values.Count -eq 0){
    Write-Host
    Write-Host "Vynae"
    Write-Host "    A PowerShell tool for extracting process Information"
    Write-Host
    Write-Host "Created By Liam Powell for use in NCCDC 2022-23"
    Write-Host
    Write-Host "For usage details, see Vynae -help"
    Write-Host
    exit
}
if(-Not $Trace -and -Not $Hash -And -Not $Help -And -Not $Service){
    ProcessInformation  
}
