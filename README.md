# Vynae - A PowerShell tool for extracting process information.
# About
Vynae is a PowerShell tool that displays key process information and supports a variety of searching methods and process tracing. For example, Vynae can trace a process back to it's originating process, or list all processes spawned by a given PPID. Processes can also be selectively displayed, such as listing only processes with a network state of 'Established'. Vynae also supports hash comparisons between active processes and known-malicious files. Currently, Vynae only supports output through Start-Transcript which is accessed with -Output. Output can also be directed to a file using 

    Vynae -SomeParameter SomeArgument *> SomeFile.txt

Which redirects the console stream to a file.

Usage

    -ID Used to pull information on a specific ProcessID

    -PPID Used to list all processes spawned by the given PPID

    -Name Used to pull information on ALL processes whose names match the value

    -Trace Used to trace a process ParentProcessID back to the originating process
            Must specify a -Name or -ID

    -NetOnly Used to only pull processes with network connections

    -NetStatus Used to only pull processes with matching network connection states

    -Output Specifies the output path for the PowerShell transcript of the session

    -Hash Hashes each process executable and compares it to the list Hashes.txt
            Alerts on matched hashes and processes without executable paths
            Hide No Path alerts with -NoPath, and hide No match found messages with -AlertOnly.

    -Help Displays this menu
    
# History
This project started as an offshoot of a small script written for CCDC wherein I needed to quickly identify key information about a specific process without access to Process Explorer. I've developed it further in my spare time, and plan on adding additional features over time. Ideally, it will be a light-weight CLI tool for quickly accessing process information.


