param($Mode,$Path=(get-location))
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
function IPDetect{
    $Address = Get-WinEvent -FilterHash @{LogName='security';ID=4625} | Select-Object Message | Format-Table -wrap | findstr "Source Network Address" | Select-String -Pattern "Source Network Address"
    $Address = $Address -split ' ' -replace '(Address:)','' -match '(.)(\d)*'
    $Address = $Address -replace '(Network)'
    $Address = $Address -replace '(Source)'
    $Address = $Address | ? {$_ -match '(\d)'}
    $LogTime = Get-WinEvent -FilterHash @{LogName='security';ID=4625} | Select-Object TimeCreated
    # $LogTime
    $AddressArray =@()
    foreach($x in $Address){
        if($x.Trim() -ne '::1'){
            $AddressArray += $x
        }
        if($AddressArray -match $x){
            $fa = $x.Trim()
            try{
                if(-not (Get-NetFirewallRule -DisplayName "IP Ban $fa")){
                    New-NetFirewallRule -Action Block -Description "Auto block on failed log on" -Direction Inbound -Protocol TCP -RemoteAddress $fa -DisplayName "IP Ban $fa"
                    New-NetFirewallRule -Action Block -Description "Auto block on failed log on" -Direction Inbound -Protocol UDP -RemoteAddress $fa -DisplayName "IP Ban $fa"
                }
            }
            catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
            }
        }
    }
}
function Task{
    [string]$scheduledtask = get-content "$Path\Modules\BlackWall.xml"
    $scheduledtask = $scheduledtask.replace('$Path',"$Path\Modules\VynaeBlackWall.ps1")
    $scheduledtask | out-string
    Register-ScheduledTask -Xml $scheduledtask -TaskName "Vynae BlackWall"
}

if($Mode -eq 'Task'){
    Task
    }
if($Mode -eq 'Control'){
        IPDetect
        Stop-ScheduledTask -TaskName "Vynae BlackWall"
    }else{
            Write-Host "Not launched in Task or Control Modes, see Vynae for help"
        }