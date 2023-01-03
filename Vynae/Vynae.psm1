<#
 .Synopsis
  A PowerShell tool for extracting process information

 .Description
  Provides a variety of filtering options for examining running processes. Parameters marked with [Filter] must not be empty. Multiple filters can be used together. See Get-Help Vynae -Examples for more information.

 .Parameter Default
  Run a default scan that lists process ID, Name, Parent Process Name, Parent Process ID, Parent Process Path, Creation Date, Active Time, CSName, Executable Path, and Command Line options.

 .Parameter ID
  [Filter] The ID of a process.

 .Parameter Name
  [Filter] The name of a process.

 .Parameter ParentID
  [Filter] The parent ID of a process.
    
 .Parameter Service
  Show services instead of processes.

 .Parameter ServiceState
  [Filter] Sort services by status [Running or Stopped]

 .Parameter Trace
  Display process tree for given process. Must use with ID or Name parameters.
  
 .Parameter LocalAddress
  [Filter] The local address of a connection.

 .Parameter RemoteAddress
  [Filter] The remote address of a connection.

 .Parameter LocalPort
  [Filter] The local port of a connection.

 .Parameter RemotePort
  [Filter] The remote port of a connection.

 .Parameter NetOnly
  Only show processes with network connections.

 .Parameter NetSupress
  Do not show network information.

 .Parameter NetStatus
  [Filter] Show only processes with network connections matching the given status.

 .Parameter Time
  [Filter] Show processes that started at a given time [0-24].

 .Parameter Date
  [Filter] Show only process started on a given day ["00/00/0000"].

 .Parameter TimeActive
  [Filter] Show only processes that have been active for a given period of time [0-24].

 .Parameter MatchHash
  [Filter] Show only processes that match a given hash. If Algorithm is not specified, it defaults to SHA-256.

 .Parameter Algorithm
  [Filter] Specify an algorithm to use with MatchHash. Also, displays hashes for processes when run with Default.

 .Parameter Hash
  Compare all process hashes to a specified hash list. Alerts on matches. Must be in a .txt file. 

 .Parameter NoPath
  Hide "no path" alerts when using Hash parameter.

 .Parameter AlertOnly
  Only display alerts when using Hash parameter.

 .Parameter Output
  Create a PowerShell transcript for all ouput. Must specify a file to write to. 

 .Parameter Help
  Display help.

 .Parameter Colorblind
  Change coloring from Green/Red to Cyan/Magenta.

 .Example 
   # Run a default scan.
   Vynae -Default

 .Example
   # List all processes with a parent ID of 4.
   Vynae -ParentID 4

 .Example 
   # List all processes that have been active for 6 hours on June 2nd, while hiding connection information.
   Vynae -NetSupress -TimeActive 6 -Date '6/2' 

 .Example 
   # List all processes with a connection to 8.8.8.8
   Vynae -RemoteAddress 8.8.8.8

 .Example
   # List all processes that match the MD5 Hash B7F884C1B74A263F746EE12A5F7C9F6A and have network connections.
   Vynae -Default -NetOnly -MatchHash B7F884C1B74A263F746EE12A5F7C9F6A -Algorithm md5

 .Example
   # List all running services, while hiding connection information.
   Vynae -Service -ServiceState Running -NetSupress

 .Example
   # Show all processes matching the name "chrome" that have an established connection.
   Vynae -name chrome -NetStatus Established
 
 .Link
   https://github.com/lpowell/Vynae
#>
function Vynae{
    param($ID, $Name, $Hash, [switch]$Trace, [switch]$NetOnly, [switch]$help, [switch]$AlertOnly, [switch]$NoPath, [switch]$Service, [switch]$NetSupress, [switch]$Colorblind, $Time, $Date, $TimeActive, $ServiceState, $ParentID, $NetStatus, $Output, [switch]$Default, $Algorithm, $MatchHash, $RemoteAddress, $LocalAddress, $LocalPort, $RemotePort)
    GlobalOptions
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
        break
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
        Write-Host
        Write-Host "    A PowerShell tool for extracting process information"
        Write-Host
        Write-Host "Created By Liam Powell for use in NCCDC 2022-23"
        Write-Host
        Write-Host "For usage details, see Vynae -help"
        Write-Host "For examples, see https://www.github.com/lpowell/vynae"
        Write-Host "For more information, please visit https://blog.bajiri.com"
        break
    }
    if(-Not $Trace -and -Not $Hash -And -Not $Help -And -Not $Service){
        ProcessInformation  
    }
}
function ProcessInformation(){
    if($Name){
        if($NetOnly -or $NetStatus){
            foreach($x in (get-ciminstance CIM_Process | ? Name -match $Name)){
                try{
                    $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID -State $NetStatus
                    if($NetStatus -eq $null){
                        throw
                    }
                    }catch{
                        $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID 
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
                            $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID -State $NetStatus
                            if($NetStatus -eq $null){
                                throw
                            }
                            }catch{
                                $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID 
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
                }elseif($LocalAddress){
                    foreach($x in (get-ciminstance CIM_Process)){
                        $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID -LocalAddress $LocalAddress
                        if($TestNetConnection){
                            ProcessPrint($x)
                        }
                    }
                    }elseif($RemoteAddress){
                    foreach($x in (get-ciminstance CIM_Process)){
                        $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID -RemoteAddress $RemoteAddress
                        if($TestNetConnection){
                            ProcessPrint($x)
                        }
                    }
                    }elseif($LocalPort){
                        foreach($x in (get-ciminstance CIM_Process)){
                            $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID -LocalPort $LocalPort
                            if($TestNetConnection){
                                ProcessPrint($x)
                            }
                        }
                        }elseif($RemotePort){
                            foreach($x in (get-ciminstance CIM_Process)){
                                $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID -RemotePort $RemotePort
                                if($TestNetConnection){
                                    ProcessPrint($x)
                                }
                            }
                            }else{
                if($NetOnly -or $NetStatus){
                    foreach($x in (get-ciminstance CIM_Process)){
                        try{
                            $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID -State $NetStatus
                            if($NetStatus -eq $null){
                                throw
                            }
                            }catch{
                                $TestNetConnection = get-nettcpconnection -OwningProcess $x.ProcessID 
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
#Print Filters and Information print functions
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
    if($MatchHash){
        try{
            if((Get-FileHash $Process.ExecutablePath -algorithm $algorithm).Hash -ne $MatchHash){
                throw
            }
            write-host $Process.ExecutablePath
        }catch{
            return
        }
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
        $ProcessHashOut =  (Get-FileHash $Process.ExecutablePath -algorithm $algorithm)
       Write-Host "Executable Path:" $Process.ExecutablePath 
       if($Algorithm){
        Write-Host "Executable $Algorithm Hash:" $ProcessHashOut.Hash
       }
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
            Write-Host " ALL ADDRESSES " -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.LocalPort
        }elseif($Conn.LocalAddress -eq '::1'){
            Write-Host "Local IPv6 Address/Port:" -NoNewLine
            Write-Host " LOCALHOST " -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.LocalPort
            }else{
            Write-Host "Local IPv6 Address/Port: " $Conn.LocalAddress ":" $Conn.LocalPort   
        }
        if($Conn.RemoteAddress -eq '::'){
            Write-Host "Remote IPv6 Address/Port:" -NoNewLine
            Write-Host " ALL ADDRESSES " -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.RemotePort
        }else{
            Write-Host "Remote IPv6 Address/Port:" $Conn.RemoteAddress ":" $Conn.RemotePort
        }
    }else{
        if($Conn.LocalAddress -eq '0.0.0.0'){
            Write-Host "Local IPv4 Address/Port:" -NoNewLine
            Write-Host " ALL ADDRESSES " -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.LocalPort
        }elseif($Conn.LocalAddress -eq '127.0.0.1'){
            Write-Host "Local IPv4 Address/Port:" -NoNewLine
            Write-Host " LOCALHOST " -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.LocalPort
        }else{
            Write-Host "Local IPv4 Address/Port:" $Conn.LocalAddress ":" $Conn.LocalPort
        }
        if($Conn.RemoteAddress -eq '0.0.0.0'){
            Write-Host "Remote IPv4 Address/Port:" -NoNewLine
            Write-Host " ALL ADDRESSES " -ForegroundColor $BadColor -NoNewLine
            Write-Host ":" $Conn.RemotePort
        }elseif($Conn.RemoteAddress -eq '127.0.0.1'){
            Write-Host "Local IPv4 Address/Port:" -NoNewLine
            Write-Host " LOCALHOST " -ForegroundColor $BadColor -NoNewLine
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
        $HashList = Get-Content $Hash
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
    Write-Host "    -LocalAddress/RemoteAddress" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to search processes by remote or local address. Supports IPv4 and IPv6 addresses"
    Write-Host
    Write-Host "    -Time -Date -TimeActive" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Used to filter by date [str], time [int 0-23], and time active(hours) [int 0-23]"
    Write-Host
    Write-Host "    -MatchHash" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Specify a hash value to search for"
    Write-Host
    Write-Host "    -Algorithm" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Specify algorith to use with -MatchHash"
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
    Write-Host "    -Help" -ForegroundColor $GoodColor -NoNewLine
    Write-Host " Displays this menu"
    Write-Host
    Write-Host "Running with no parameters will scan all processes and list process information and network information"
    Write-Host
}
Export-ModuleMember -Function Vynae