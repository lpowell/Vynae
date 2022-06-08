# Vynae module 1
# Hashing expansion
# Scheduled task to compare hashed values against a control set
# .\Vynae.ps1 -Module IntegrityCheck -Mode Task
param($Mode,$Path=(get-location),$Minutes=20)

function ScheduleTask{
    $path = $PSScriptRoot
    $stpath = $PSScriptRoot+"\VynaeIntegrityCheck.ps1"
    # $path = $path -replace "\s","`` "
    $User = "NT AUTHORITY\SYSTEM"
    $command = "'$stpath' -Mode Task -Path '$path'"
    $Argument = "-command `"& $command`""
    $Action = New-ScheduledTaskAction -Execute "Powershell.exe" $Argument
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $Minutes)
    Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Vynae Integrity Check" -Description "Compare process hash against control list"
}

function CreateControl{
    Remove-Item "$Path\HashList.csv"
    get-ciminstance cim_process | Export-csv -Path "$Path\HashList.csv"
}


# function CreateControl{
#     Remove-Item HashList.csv
#     $MissingPath =@()
#     foreach($x in get-ciminstance cim_process){
#         try{
#             if($x.ExecutablePath){
#                 get-filehash $x.ExecutablePath | Export-csv HashList.csv -Append
#                 }else{
#                     throw
#                 }
#         }catch{
#             $name = $x.Name
#             $ProcID = $x.ProcessID
#             if($MissingPath -notcontains $name){
#                 $MissingPath += $x
#             }
#         }
#     }
#     if($MissingPath){
#         $MissingPath |Select-Object -Property ProcessID, ParentProcessID, Name, CreationDate | out-gridview -title "Could not find an Executable Path -- Are you Administrator?"
#         # $Return = [System.Windows.Forms.ListBox]::Show("$MissingPath")
#         # start Powershell -ArgumentList "& {[console]::windowwidth=80; [console]::windowheight=45; [console]::bufferwidth=[console]::windowwidth;write-host $MissingPath; Read-Host}"
#         # write-host $MissingPath
#     }
# }

function CompareHash{
    get-ciminstance cim_process | Export-csv -Path "$Path\HashTest.csv"
    $ControlFile = import-csv -Path $Path\HashList.csv
    $TestFile = import-csv -Path $Path\HashTest.csv
    compare-object -referenceobject $ControlFile -differenceobject $TestFile -passthru | out-gridview -title "Process not found in control file"
}
# function CompareHash{
#     $Control = import-csv $Path"\HashList.csv"
#     $Found =@()
#     $Sendout =@()
#     foreach($x in get-ciminstance cim_process){
#         foreach($y in $Control){
#             if($y.Path -eq $x.ExecutablePath){
#                 $Test = get-filehash $x.ExecutablePath
#                 $Found += $x
#                 if($y.Hash -ne $Test.Hash){
#                     $control | Select-Object -Property Path, Hash | out-gridview -Title "These hashes did not match" -wait
#                     # start Powershell -ArgumentList "& {[console]::windowwidth=20; `
#                     # [console]::windowheight=5; [console]::bufferwidth=[console]::windowwidth; `
#                     # write-host Alert!-- Process $x.Name  does not match it's previous hash!;write-host `
#                     # Control Hash $Control.Hash;write-host New Hash $Test.Hash Read-Host}"

#                 }
#             }
#         }
#     }
#     foreach($x in $Found){
#         if($x -notin $Control){
#             $Sendout += $x
#             # start Powershell -ArgumentList "& {[console]::windowwidth=20; [console]::windowheight=5; [console]::bufferwidth=[console]::windowwidth;`
#             #     Write-Host Found new process $x.Name with path of $x.ExecutablePath; Read-Host}"
#         }
#     }
#     if($Sendout -ne $null){
#         $Sendout | Select-Object -Property ProcessID, ParentProcessID, Name, CreationDate, ExecutablePath | out-gridview -Title "New Processes"
#     }
# }
# Add-Type -AssemblyName System.Windows.Forms | Out-Null
# $Return = [System.Windows.Forms.MessageBox]::Show("$test")
if($Mode -eq 'Control'){
    CreateControl
    ScheduleTask
}elseif($Mode -eq 'Task'){
    # [Void] [Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
    # start Powershell -ArgumentList "& {write-host test; [Microsoft.VisualBasic.Interaction]::MessageBox(`"Test`")}"
    CompareHash
}