function PIDHUNTER{
    $nethold =@()
	foreach($x in (get-nettcpconnection | format-list LocalAddress,LocalPort, State, RemoteAddress, RemotePort, OwningProcess, CreationTime)){
        $nethold += $x
    }
    foreach($a in (out-string -InputObject $nethold)){
        $NetSplit = $a.Split([Environment]::NewLine)
        foreach($b in (($NetSplit | findstr OwningProcess).Split(':'))){
            try{
                gwmi win32_process | ? processid -eq $b | format-list ProcessId, Name, ExecutablePath, CommandLine
                get-nettcpconnection | ? OwningProcess -eq $b
            }catch{}
        }
    }
}
PIDHUNTER