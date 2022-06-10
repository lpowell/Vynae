param($Mode,$Path=(get-location),$Minutes=20)
# Change minutes either in the script, or by calling the module directly through the shell

function GlobalOptions(){
    $global:ErrorActionPreference="SilentlyContinue"
    if($Colorblind){
        $global:GoodColor = 'cyan'
        $global:BadColor = 'magenta'
        }else{
            $global:GoodColor = 'green'
            $global:BadColor = 'red'
        }
}

function ScheduleTask{
    Unregister-ScheduledTask -TaskName "Vynae Integrity Check" -Confirm:$false
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File `"$Path\Modules\VynaeIntegrityCheck.ps1`" -Mode `"Task`" -Path `"$Path`""
    $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $Minutes)
    Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Vynae Integrity Check" -Description "Compare process hash against control list"

    Unregister-ScheduledTask -TaskName "Vynae Integrity Check - Control" -Confirm:$false
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File `"$Path\VynaeIntegrityCheck.ps1`" -Mode `"Control`" -Path `"$Path`""
    $Trigger = New-ScheduledTaskTrigger -AtStartup 
    Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "Vynae Integrity Check - Control" -Description "Create a control list for the current session"
}

function CreateControl{
    Remove-Item "$Path\HashList.csv"
    get-ciminstance cim_process | Export-csv -Path "$Path\ProcList.csv"
}

function CompareList{
    get-ciminstance cim_process | Export-csv -Path "$Path\ProcTest.csv"
    $ControlFile = import-csv -Path $Path\ProcList.csv
    $TestFile = import-csv -Path $Path\ProcTest.csv
    compare-object -referenceobject $ControlFile -differenceobject $TestFile -passthru | out-gridview -title "Processes not found in control file"
    read-host
}

GlobalOptions
if($Mode -eq 'Control'){
    CreateControl
    Write-Host "Control Created"
    ScheduleTask
    Write-Host "Schedule Task Created"
}elseif($Mode -eq 'Task'){
    CompareList
}else{
    write-host "Not running in Task or Control modes, see Vynae or the GitHub for more information"
    read-host
}