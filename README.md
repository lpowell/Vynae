# Vynae - A PowerShell tool for extracting process information.
# About
Vynae is a PowerShell tool that displays key process information and supports a variety of searching methods and process tracing. For example, Vynae can trace a process back to it's originating process, or list all processes spawned by a given PPID. Processes can also be selectively displayed, such as listing only processes with a network state of 'Established'. Vynae also supports hash comparisons between active processes and known-malicious files. 

Vynae also has partial support for service scanning as well. Service scans can be filtered by name or state, and Vynae will attempt to pull network information. Service scans can also access the networking options NetSupress, NetStatus, and NetOnly.

Vynae now has a GUI under development! It uses windows forms via the .net framework. Because I've decided that Vynae should remain 100% PowerShell for some reason, I've manually written the entire GUI in sublime instead of using VisualStudio's nice editor. Right now, it supports the same level of information as a net suppressed default scan. It shows Process Name, ID, Parent Name, Parent ID, Creation Date, Location, Hash, and Command Line Arguments. The next thing being wokred on will be networking information, followed by adding a filtering function via a search bar at the top. 

Currently, Vynae only supports output through Start-Transcript which is accessed with -Output. Output can also be directed to a file using 

    Vynae -SomeParameter SomeArgument *> SomeFile.txt

Which redirects the console stream to a file.

## Modules
    
   Integrity
   
   &emsp;An addon that creates a control list of processes and regularly checks the control list to the current list of processes and reports diffrences.
   
   RegCheck
   
   &emsp;An addon that enumerates Run keys in HKLM and HKCU Run and RunOnce locations. It also compares hashes of items in C:\Windows\Temp to a list of known malicious hashes.

   BlackWall
    
   This module creates a scheduled task that auto bans addresses that try (and fail) to logon remotely. 
    
More module information can be found in the wiki

## Usage

    -Default Runs Vynae's process information gatherer
        Gathers Name, ID, PPID Name, PPID, PPID Path, Creation Date, Active Time
        CSName, Executable Path, and Command Line options

        Filter with ID, Name, ParentID, Time options, or Net options
        
    -ID Used to pull information on a specific ProcessID

    -ParentID Used to list all processes spawned by the given ParentID

    -Name Used to pull information on ALL processes whose names match the value

    -Trace Used to trace a process ParentProcessID back to the originating process
            Must specify a -Name or -ID
            
    -MatchHash Specify a hash value to search for

    -Algorithm Specify algorith to use with -MatchHash

    -Time -Date -TimeActive Used to filter by date [str], time [int 0-23], and time active [int 0-23]

    -Colorblind Uses magenta and cyan colors to helpfully alleviate colorblind issues

    -NetOnly Used to only pull processes with network connections

    -NetStatus Used to only pull processes with matching network connection states

    -NetSupress Used to hide network information.

    -Service Used to scan services instead of processes
            Use -ServiceState to filter by Running/Stopped

    -Output Specifies the output path for the PowerShell transcript of the session

    -Hash Hashes each process executable and compares it to the list Hashes.txt
            Alerts on matched hashes and processes without executable paths
            Hide No Path alerts with -NoPath, and hide No match found messages with -AlertOnly.
            
    -Module            Runs modules in /Modules

    -Help Displays this menu
    
    
## Example usage

    Vynae -Service -ServiceState Running -NetSupress
    
This will show all running services without network information

    Vynae -name chrome -NetStatus Established
    
This will list chrome processes with and its Established connections

    Vynae -ParentID 4
    
This will list all processes with a parent ID of 4 

    Vynae -Trace -Name chrome -NetSupress
    
This will trace back every chrome process to its origination point. E.g. 9404 -> 1652 -> 4708 -> 7744

    Vynae -NetOnly 
    
This will list all processes with a network connection

    Vynae -hash -name chrome

This will compare the hash of every unique chrome process (by executable path) to a list on know-malicious file hashes

    Vynae -hash -NoPath -AlertOnly

This will hash all active processes, only showing alerts and supressing the 'No file path' alerts

    Vynae -NetSupress -TimeActive 6 -Date '6/2' 
 
 This will display processes that have been active for 6 hours on June 2nd
 
    Vynae -NetOnly -Name chrome -Colorblind
    
This will display chrome processes with network connections with more colorblind-friendly colors (Magenta and Cyan)
    
# History
This project started as an offshoot of a small script written for CCDC wherein I needed to quickly identify key information about a specific process without access to Process Explorer. I've developed it further in my spare time, and plan on adding additional features over time. Ideally, it will be a light-weight CLI tool for quickly accessing process information.


