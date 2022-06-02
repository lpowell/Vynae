param($ID, $Name, [switch]$Hash, [switch]$Trace, [switch]$NetOnly, [switch]$help, [switch]$AlertOnly, [switch]$NoPath, [switch]$Service, [switch]$NetSupress, [switch]$Colorblind, $Time, $Date, $TimeActive, $ServiceState, $ParentID, $NetStatus, $Output)


function GlobalOptions() {
    $global:DateTime = Get-Date
    $global:ErrorActionPreference = "SilentlyContinue"
    if ($Colorblind) {
        $global:GoodColor = 'cyan'
        $global:BadColor = 'magenta'
    }
    else {
        $global:GoodColor = 'green'
        $global:BadColor = 'red'
    }
}

function ProcessPrint($Process) {
    $ActiveTime = New-TimeSpan -Start $Process.CreationDate -End $DateTime
    if ($Date -And $Process.CreationDate.Date -notcontains $Date) {
        return
    }
    if ($Time -in 0..24 -And $Process.CreationDate.Hour -ne [int]$Time) {
        return
    }
    if ($TimeActive -in 0..24 -And $ActiveTime.Hours -ne [int]$TimeActive) {
        return
    }
    $ParentPath = Get-CimInstance CIM_Process | Where-Object ProcessID -EQ $Process.ParentProcessID 
    Write-Host "<-----Process Information----->" -ForegroundColor $GoodColor 
    Write-Host "Process Name: " -NoNewline
    Write-Host $Process.ProcessName -ForegroundColor $GoodColor
    Write-Host "Process ID: " -NoNewline
    Write-Host $Process.ProcessId -ForegroundColor $GoodColor
    Write-Host "PPID Name: " -NoNewline
    Write-Host $ParentPath.Name -ForegroundColor $GoodColor
    Write-Host "Process PPID: " -NoNewline
    Write-Host $Process.ParentProcessID -ForegroundColor $GoodColor
    if ($ParentPath.ExecutablePath) {
        Write-Host "PPID Path:" $ParentPath.ExecutablePath 
    } 
    if ($Process.CreationDate) {
        Write-Host "Creation Date:" $Process.CreationDate
        Write-Host "Active for: " $ActiveTime.Hours 'Hours' $ActiveTime.Minutes 'Minutes'
    }
    Write-Host "CSName:" $Process.CSName
    if ($Process.ExecutablePath) {
        Write-Host "Executable Path:" $Process.ExecutablePath 
    }
    if ($Process.CommandLine) {
        Write-Host "Command Line:" $Process.CommandLine
    }
    Write-Host
    NetworkInformation($Process.ProcessID)
}

function NetworkPrint($Conn) {
    Write-Host "State: " -NoNewline
    Write-Host $Conn.State -ForegroundColor $GoodColor
    if ($Conn.LocalAddress | Select-String -Pattern "::") {
        if ($Conn.LocalAddress -eq '::') {
            Write-Host "Local IPv6 Address/Port: " -NoNewline
            Write-Host "any" -ForegroundColor $BadColor -NoNewline
            Write-Host " :" $Conn.LocalPort
        }
        else {
            Write-Host "Local IPv6 Address/Port: " $Conn.LocalAddress ":" $Conn.LocalPort   
        }
        if ($Conn.RemoteAddress -eq '::') {
            Write-Host "Remote IPv6 Address/Port: " -NoNewline
            Write-Host "any" -ForegroundColor $BadColor -NoNewline
            Write-Host " :" $Conn.RemotePort
        }
        else {
            Write-Host "Remote IPv6 Address/Port:" $Conn.RemoteAddress ":" $Conn.RemotePort
        }
    }
    else {
        if ($Conn.LocalAddress -eq '0.0.0.0') {
            Write-Host "Local IPv4 Address/Port: " -NoNewline
            Write-Host "any" -ForegroundColor $BadColor -NoNewline
            Write-Host " :" $Conn.LocalPort
        }
        else {
            Write-Host "Local IPv4 Address/Port:" $Conn.LocalAddress ":" $Conn.LocalPort
        }
        if ($Conn.RemoteAddress -eq '0.0.0.0') {
            Write-Host "Remote IPv4 Address/Port: " -NoNewline
            Write-Host "any" -ForegroundColor $BadColor -NoNewline
            Write-Host " :" $Conn.RemotePort
        }
        else {
            Write-Host "Remote IPv4 Address/Port:" $Conn.RemoteAddress ":" $Conn.RemotePort
        }
    }
    Write-Host
}

function ProcessTrace($Process) {
    if ((Get-CimInstance CIM_Process | Where-Object ProcessId -EQ $Process.ParentProcessID) -And [int]$Process.ProcessId -ne 0) {
        $ID = $Process.ParentProcessID
        ParentProcessTracing
    }
    else {
        Write-Host "<--Process cannot Be traced further-->" -ForegroundColor $BadColor
    }
}

# if name elif id else default && use params for name and id
function ProcessInformation() {
    if ($Name) {
        if ($NetOnly -or $NetStatus) {
            foreach ($x in (Get-CimInstance CIM_Process | Where-Object Name -Match $Name)) {
                try {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID | Where-Object State -EQ $NetStatus
                    if ($null -eq $NetStatus) {
                        throw
                    }
                }
                catch {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID 
                }
                if ($TestNetConnection) {
                    ProcessPrint($x)
                }
            }
        }
        else {
            foreach ($x in (Get-CimInstance CIM_Process | Where-Object Name -Match $Name)) {
                ProcessPrint($x)
            }
        }
    }
    elseif ($ID) {
        foreach ($x in (Get-CimInstance CIM_Process | Where-Object ProcessID -EQ $ID)) {
            ProcessPrint($x)
        }
    }
    elseif ($ParentID) {
        if ($NetOnly -or $NetStatus) {
            foreach ($x in (Get-CimInstance CIM_Process | Where-Object ParentProcessID -EQ $ParentID)) {
                try {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID | Where-Object State -EQ $NetStatus
                    if ($null -eq $NetStatus) {
                        throw
                    }
                }
                catch {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID 
                }
                if ($TestNetConnection) {
                    ProcessPrint($x)
                }
            }
        }
        else {
            foreach ($x in (Get-CimInstance CIM_Process | Where-Object ParentProcessID -EQ $ParentID)) {
                ProcessPrint($x)
            }
        }
    }
    else {
        if ($NetOnly -or $NetStatus) {
            foreach ($x in (Get-CimInstance CIM_Process)) {
                try {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID | Where-Object State -EQ $NetStatus
                    if ($null -eq $NetStatus) {
                        throw
                    }
                }
                catch {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID 
                }
                if ($TestNetConnection) {
                    ProcessPrint($x)
                }
            }
        }
        else {
            foreach ($x in (Get-CimInstance CIM_Process)) {
                ProcessPrint($x)
            }
        }   
    }
}

function NetworkInformation($ProcessID) {
    if ($NetSupress) {
        return
    }
    if (Get-NetTCPConnection | Where-Object OwningProcess -EQ $ProcessID | Where-Object State -EQ $NetStatus) {
        Write-Host "<-----Net Information----->" -ForegroundColor $GoodColor
        foreach ($x in (Get-NetTCPConnection | Where-Object OwningProcess -EQ $ProcessID | Where-Object State -EQ $NetStatus)) {
            NetworkPrint($x)
        }  
    }
    elseif (Get-NetTCPConnection | Where-Object OwningProcess -EQ $ProcessID) {
        Write-Host "<-----Net Information----->" -ForegroundColor $GoodColor
        foreach ($x in (Get-NetTCPConnection | Where-Object OwningProcess -EQ $ProcessID)) {
            NetworkPrint($x)
        }  
    }
}

function ParentProcessTracing() {
    if ($ID) {
        foreach ($x in Get-CimInstance CIM_Process | Where-Object ProcessID -EQ $ID) {
            ProcessPrint($x)
            ProcessTrace($x)
        }
    }
    elseif ($Name) {
        foreach ($x in Get-CimInstance CIM_Process | Where-Object ProcessName -Match $Name) {
            ProcessPrint($x)
            ProcessTrace($x)
        }
    }
}

function ProcessHashing() {
    $HashedArray = @()
    Write-Host "<----- Loading Hashes ----->" -ForegroundColor $GoodColor
    Try {
        $HashList = Get-Content Hashes.txt
        if ($null -eq $HashList) {
            throw
        }
        Write-Host
        Write-Host "<----- Hashes Successfully Loaded ----->" -ForegroundColor $GoodColor
    }
    Catch {
        Write-Host "<----- Hashes not loaded! ----->" -ForegroundColor $BadColor
        exit
    }
    if ($ID) {
        $Process = Get-CimInstance CIM_Process | Where-Object ProcessID -EQ $ID
    }
    elseif ($Name) {
        $Process = Get-CimInstance CIM_Process | Where-Object Name -Match $Name
    }
    else {
        $Process = Get-CimInstance CIM_Process 
    }
    foreach ($x in $Process) { 
        $ProcessHash = Get-FileHash $x.ExecutablePath
        $FoundHash = $False
        if (-Not $HashedArray.contains($ProcessHash.hash)) {
            if ($x.ExecutablePath) {
                foreach ($h in $HashList) {
                    if ($ProcessHash.Hash -eq $h) {
                        $FoundHash = $True
                    }
                } 
                $HashedArray += $ProcessHash.hash
                if ($FoundHash -eq $false -And -Not $AlertOnly) {
                    Write-Host "No matches found!" -ForegroundColor $GoodColor
                    ProcessPrint($x)
                }
                elseif ($FoundHash -eq $True) {
                    Write-Host "<-----Hash Comparison----->" -ForegroundColor $GoodColor
                    Write-Host
                    Write-Host "Alert -- Found match!" -ForegroundColor $BadColor
                    Write-Host "Hash of " $x.ProcessName "with ID " $x.ProcessId "and ExecutablePath of " $x.ExecutablePath "matches hash " $h
                    Write-Host
                    ProcessPrint($x)
                }
            }
            elseif (-Not $NoPath) {
                Write-Host "Alert -- Could not find Path!" -ForegroundColor $BadColor
                Write-Host "Could not find Executable Path for " $x.ProcessName " with ID " $x.ProcessID
                Write-Host
                ProcessPrint($x)
            }
        }  
    }
}

function ServiceInformation() {
    if ($Name) {
        if ($NetOnly -or $NetStatus) {
            try {
                $Services = Get-CimInstance Win32_Service | Where-Object Name -Match $Name | Where-Object State -EQ $ServiceState
                if ($null -eq $ServiceState) {
                    throw
                }
            }
            catch {
                $Services = Get-CimInstance Win32_Service | Where-Object Name -Match $Name
            }
            foreach ($x in $Services) {
                try {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $Services.ProcessID | Where-Object State -EQ $NetStatus
                    if ($null -eq $NetStatus) {
                        throw
                    }
                }
                catch {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $Services.ProcessID
                }
                if ($TestNetConnection) {
                    foreach ($y in $x) {
                        ServicePrint($x)
                    }
                }
            }
        }
        else {
            try {
                $Services = Get-CimInstance Win32_Service | Where-Object Name -Match $Name | Where-Object State -EQ $ServiceState
                if ($null -eq $ServiceState) {
                    throw
                }
            }
            catch {
                $Services = Get-CimInstance Win32_Service | Where-Object Name -Match $Name
            }
            foreach ($x in $Services) {
                ServicePrint($x)
            }
        }
    }
    else {
        if ($NetOnly -or $NetStatus) {
            try {
                $Services = Get-CimInstance Win32_Service | Where-Object State -EQ $ServiceState
                if ($null -eq $ServiceState) {
                    throw
                }
            }
            catch {
                $Services = Get-CimInstance Win32_Service 
            }
            foreach ($x in $Services) {
                try {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID | Where-Object State -EQ $NetStatus
                    if ($null -eq $NetStatus) {
                        throw
                    }
                }
                catch {
                    $TestNetConnection = Get-NetTCPConnection | Where-Object OwningProcess -EQ $x.ProcessID
                }
                if ($TestNetConnection) {
                    foreach ($y in $x) {
                        ServicePrint($x)
                    }
                }
            }
        }
        else {
            try {
                $Services = Get-CimInstance Win32_Service | Where-Object State -EQ $ServiceState
                if ($null -eq $ServiceState) {
                    throw
                }
            }
            catch {
                $Services = Get-CimInstance Win32_Service
            }
            foreach ($x in $Services) {
                ServicePrint($x)
            }
        }
    }                   
}

function ServicePrint($Service) {
    $Process = Get-CimInstance Win32_Process | Where-Object ProcessID -EQ $Service.ProcessID
    Write-Host "<-----Service Information----->" -ForegroundColor $GoodColor 
    Write-Host "Service Name: " -NoNewline
    Write-Host $Service.Name -ForegroundColor $GoodColor
    Write-Host "Service Status: " -NoNewline
    Write-Host $Service.Status -ForegroundColor $GoodColor
    Write-Host "Service State: " -NoNewline
    Write-Host $Service.State -ForegroundColor $GoodColor
    Write-Host "Process ID: " -NoNewline
    Write-Host $Service.ProcessId -ForegroundColor $GoodColor
    Write-Host "Process PPID: " -NoNewline
    Write-Host $Process.ParentProcessID -ForegroundColor $GoodColor
    Write-Host "Creation Class:" $Service.CreationClassName
    Write-Host "System Name:" $Service.SystemName
    if ($Service.PathName) {
        Write-Host "Executable Path:" $Service.PathName 
    }
    if ($Service.InstallDate) {
        Write-Host "Install Date:" $Service.InstallDate
    }
    Write-Host "Description: " $Service.Description
    Write-Host
}

function VynaeHelp($Action) {
    Write-Host "`nVynae:"
    Write-Host "A PowerShell tool for extracting process information."
    Write-Host "`nUsage:"
    Write-Host "    -ID" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to pull information on a specific ProcessID"
    Write-Host "`n    -ParentID" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to list all processes spawned by the given ParentID"
    Write-Host "`n    -Name" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to pull information on ALL processes whose names match the value"
    Write-Host "`n    -Trace" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to trace a process ParentProcessID back to the originating process"
    Write-Host "             Must specify a -Name or -ID"
    Write-Host "`n    -Time -Date -TimeActive" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to filter by date [str], time [int 0-23], and time active [int 0-23]"
    Write-Host "`n    -Colorblind" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Uses magenta and cyan colors to helpfully alleviate colorblind issues"
    Write-Host "`n    -NetOnly" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to only pull processes with network connections"
    Write-Host "`n    -NetStatus" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to only pull processes with matching network connection states"
    Write-Host "`n    -NetSupress" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to hide network information."
    Write-Host "`n    -Service" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Used to scan services instead of processes"
    Write-Host "               Use -ServiceState to filter by Running/Stopped"
    Write-Host "`n    -Output" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Specifies the output path for the PowerShell transcript of the session"
    Write-Host "`n    -Hash" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Hashes each process executable and compares it to the list Hashes.txt"
    Write-Host "            Alerts on matched hashes and processes without executable paths"
    Write-Host "            Hide No Path alerts with -NoPath, and hide No match found messages with -AlertOnly."
    Write-Host "`n    -Help" -ForegroundColor $GoodColor -NoNewline
    Write-Host " Displays this menu"
    Write-Host "`nRunning with no parameters will scan all processes and list process information and network information.`n"
}
GlobalOptions
if ($Output) {
    Start-Transcript -Path $output -Append
}
if ($Service) {
    ServiceInformation
}
if ($Trace) {
    ParentProcessTracing
}
if ($Hash) {
    ProcessHashing
}
if ($Help) {
    VynaeHelp
}
if (-Not $Trace -and -Not $Hash -And -Not $Help -And -Not $Service) {
    ProcessInformation  
}
if ($Output) {
    Stop-Transcript
}
