# Vynae - A PowerShell tool for extracting process information using CIM.
# Usage
Currently allows for Parent Process tracing, network connection, execution path & launch command, and options to search by name or ID.
Usage

    -ID Used to pull information on a specific ProcessID

    -Name Used to pull information on ALL processes whose names match the value

    -Trace Used to trace a process' ParentProcessID back to the originating process
            Must specify a -Name or -ID

    -NetOnly Used to only pull processes with matching nettcpconnections
            Can only be used with -Name or defaults

    Running with no parameters will scan all processes and list process information and network information
# History
This project started as an offshoot of a small script written for CCDC wherein I needed to quickly identify key information about a specific process without access to Process Explorer. I've developed it further in my spare time, and plan on adding additional features over time. Ideally, it will be a light-weight CLI tool for quickly accessing process information.


