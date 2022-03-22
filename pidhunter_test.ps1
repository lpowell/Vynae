### list active connections and then grab the pid of the process as well as the location it's running out off and the parent process id

function netuse{
#    $processhold =@()
    $nethold =@()
#    $temphold =@()
#    $add = 0
#    #foreach($x in get-nettcpconnection){
#        #try{
#        #    $processhold += $x | %{out-string -InputObject $_.OwningProcess} |%{get-process -id $_} | format-list ProcessName, Path
#        #}catch{
#        #    $processhold += "Could not resolve ID $x" 
#        #}
#        #try{
#        #    $nethold += $x | format-list LocalAddress,LocalPort, State, RemoteAddress, RemotePort, OwningProcess, CreationTime
#        #}catch{
#        #    nethold += "Could not list information"
#        #}
#    #}
#    foreach($x in get-nettcpconnection | %{out-string -InputObject $_.OwningProcess} |%{get-process -id $_} | format-list ProcessName, Path){
#        $processhold = $x
#    }
#    foreach($x in get-nettcpconnection | format-list LocalAddress,LocalPort, State, RemoteAddress, RemotePort, OwningProcess, CreationTime){
#        $nethold = $x
#    }
#    foreach($x in get-nettcpconnection){
#        $temphold = $x
#    }
#    export-csv -InputObject $processhold -Path $env:UserProfile\Desktop\NetUse.csv
#    export-csv -InputObject $nethold -Path $env:UserProfile\Desktop\NetUse.csv
#    foreach($x in $processhold){
#        echo $nethold >> $env:UserProfile\Desktop\pid.txt
#        echo $processhold >> $env:UserProfile\Desktop\pid.txt
#    }


foreach($x in (get-nettcpconnection | format-list LocalAddress,LocalPort, State, RemoteAddress, RemotePort, OwningProcess, CreationTime)){
    $nethold += $x
}
foreach($a in (out-string -InputObject $nethold)){
    $NetSplit = $a.Split([Environment]::NewLine)
    foreach($b in (($NetSplit | findstr OwningProcess).Split(':'))){
    try{
        #get-process -id $x | format-list Id, Name, Path
        #(get-process -id $x).path
        gwmi win32_process | ? processid -eq $b | format-list ProcessId, Name, ExecutablePath, CommandLine
        get-nettcpconnection | ? OwningProcess -eq $b
        $PIDTEST = $b
        #while($exit -eq $false){
        #    if((gwmi win32_process | ? processid -eq $PIDTEST).parentprocessid -eq ''){
        #        $exit -eq $true
        #    }else{
        #        $PIDTEST = (gwmi win32_process | ? processid -eq $PIDTEST).parentprocessid
        #    }

        #}
        #echo "Parent ID: $PIDTEST"
        #echo 'Open on'
        #if($NetSplit -match $x){
        #    
        #}
    }catch{}
}
}

#echo ($PIDhold | findstr OwningProcess).Split(':')
$exit = $false

foreach($x in $PIDHold){
    echo $x
}
# function ParentProcess($Id){
#     $a =@()
#     $x = 0
#     $exit = $false
#     echo 'Test-a'
#     while($exit -ne $true){
#         echo 'Test-b'
#         $a[$x] += (gwmi win32_process | ? processid -eq $Id).parentprocessid
#         if($a[$x] -eq ''){
#             echo 'Parent Processes'
#             foreach($b in $a){
#                 echo $b
#             }
#             $exit = $true
#         }else{
#             $Id = $a[$x]
#         }
#         $x++
#     }
# }

#Replace("[^0-9]",'')
#($PIDhold | findstr OwningProcess).Split(':')
# foreach($x in $nethold){
#     $NOWN = $x | findstr OwningProcess
#     get-process -id ($NOWN -replace "{^0-9}", '')
# }
# echo $nethold[1]




#get-nettcpconnection | %{out-string -InputObject $_.OwningProcess} |%{get-process -id $_} | format-list ProcessName, Path






    echo $nethold.count
    echo $processhold.count
    echo $temphold.count
    $udp = get-netudpendpoint | format-list LocalAddress, LocalPort, State, OwningProcess, CreationTime

}

netuse