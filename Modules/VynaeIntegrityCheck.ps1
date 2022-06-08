param($Mode,$Path=(get-location),$Minutes=20)
# Change minutes either in the script, or by calling the module directly through the shell

function ScheduleTask{
    Unregister-ScheduledTask -TaskName "Vynae Integrity Check" -Confirm:$false
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File `"$Path\Modules\VynaeIntegrityCheck.ps1`" -Mode `"Task`" -Path `"$Path`""
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $Minutes)
    Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Vynae Integrity Check" -Description "Compare process hash against control list"
}

function CreateControl{
    Remove-Item "$Path\HashList.csv"
    get-ciminstance cim_process | Export-csv -Path "$Path\HashList.csv"
}

function CompareHash{
    get-ciminstance cim_process | Export-csv -Path "$Path\HashTest.csv"
    $ControlFile = import-csv -Path $Path\HashList.csv
    $TestFile = import-csv -Path $Path\HashTest.csv
    compare-object -referenceobject $ControlFile -differenceobject $TestFile -passthru | out-gridview -title "Processes not found in control file"
    read-host
}

if($Mode -eq 'Control'){
    CreateControl
    Write-Host "Control Created"
    ScheduleTask
    Write-Host "Schedule Task Created"
}elseif($Mode -eq 'Task'){
    CompareHash
    $Path
}else{
    write-host "Not running in Task or Control modes, see Vynae or the GitHub for more information"
    read-host
}