function PIDHUNTER{
    $nethold =@()
	foreach($x in (get-nettcpconnection | format-list LocalAddress, LocalPort, State, RemoteAddress, RemotePort, OwningProcess, CreationTime)){
        $nethold += $x
    }
    foreach($a in (out-string -InputObject $nethold)){
        $NetSplit = $a.Split([Environment]::NewLine)
        foreach($b in (($NetSplit | findstr OwningProcess).Split(':'))){
            try{
                gwmi win32_process | ? processid -eq $b | format-list ProcessId, ParentProcessId, Name, ExecutablePath, CommandLine
                get-nettcpconnection | ? OwningProcess -eq $b
            }catch{}
        }
    }
}
function PIDLookup($Identity){
    $test = $Identity -is [int]
    if(-not $test){
        gwmi win32_process | ? name -eq $Identity | format-list ProcessId, ParentProcessId, Name, ExecutablePath, CommandLine
        $split = gwmi win32_process | ? name -eq $Identity | format-list ProcessId
        foreach($a in (out-string -inputobject $split)){
            foreach($b in $test = $a.Split(':')){
                try{
                    get-nettcpconnection | ? OwningProcess -eq $b
                }catch{}
            }
        }
    }else{
        gwmi win32_process | ? processid -eq $Identity | format-list ProcessId, ParentProcessId, Name, ExecutablePath, CommandLine
        get-nettcpconnection | ? OwningProcess -eq $Identity
    }
}
if($Args[0]){
    PIDLookup($Args[0])
}else{
    PIDHUNTER   
}
