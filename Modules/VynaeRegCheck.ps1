param($Mode,$Colorblind,$Path)

function GlobalOptions(){
    $global:DateTime = get-date
    $global:Path =Get-location
    $global:ErrorActionPreference="SilentlyContinue"
    if($Colorblind){
        $global:GoodColor = 'cyan'
        $global:BadColor = 'magenta'
        }else{
            $global:GoodColor = 'green'
            $global:BadColor = 'red'
        }
}

function RunKeys{
    $Path =@()
    foreach($x in Get-Item -Path Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Run\){
       foreach($y in $x.Property){
        $Execute = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Run | Select-Object $y.Property
        $Path = $Execute -split("`"")
        $Hash = get-filehash $Path[1]
        Write-Host "Reg Key Name: " $y
        Write-Host "Reg Key Path: HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
        Write-Host "Executable Path: " $Hash.Path
        Write-Host "Executable Hash: " $Hash.Hash
        Write-Host
       }
        # Write-Host $Hash.Path $Hash.Hash 
    }
    foreach($x in Get-Item -Path Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce\){
        foreach($y in $x.Property){
         $Execute = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Run | Select-Object $y.Property
         $Path = $Execute -split("`"")
         $Hash = get-filehash $Path[1]
         Write-Host "Reg Key Name: " $y
         Write-Host "Reg Key Path: HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
         Write-Host "Executable Path: " $Hash.Path
         Write-Host "Executable Hash: " $Hash.Hash
         Write-Host
        }
    }
    foreach($x in Get-Item -Path Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Run\){
       foreach($y in $x.Property){
        $Execute = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run | Select-Object $y.Property
        $Path = $Execute -split("`"")
        $Hash = get-filehash $Path[1]
        Write-Host "Reg Key Name: " $y
        Write-Host "Reg Key Path: HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        Write-Host "Executable Path: " $Hash.Path
        Write-Host "Executable Hash: " $Hash.Hash
        Write-Host
       }
        # Write-Host $Hash.Path $Hash.Hash 
    }
    foreach($x in Get-Item -Path Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Run\){
       foreach($y in $x.Property){
        $Execute = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run | Select-Object $y.Property
        $Path = $Execute -split("`"")
        $Hash = get-filehash $Path[1]
        Write-Host "Reg Key Name: " $y
        Write-Host "Reg Key Path: HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
        Write-Host "Executable Path: " $Hash.Path
        Write-Host "Executable Hash: " $Hash.Hash
        Write-Host
       }
        # Write-Host $Hash.Path $Hash.Hash 
    }
}

Function TempFiles{
    Write-Host "Loading File Hashes" -Foregroundcolor $GoodColor
    Write-host
    try{
        $HashList = get-content $Path\Hashes.txt
        if($HashList -eq $null){
            throw
        }else{
            Write-Host "Hashes Loaded" -Foregroundcolor $GoodColor
            Write-Host
        }
        }catch{
            Write-Host "Hashes could not be loaded" -ForegroundColor $BadColor
            exit
        }
    foreach($x in Get-ChildItem C:\Windows\Temp\){
        $ItemHash = get-filehash $x.FullName
        if($x.Extension -ne '.log'){
            Write-Host "Hashing " $x.FullName
            Write-Host
            foreach($h in $HashList){
                if($ItemHash.Hash -eq $h){
                    Write-Host "Found a match!" -ForegroundColor $BadColor
                    Write-Host "Name: " $x.Name
                    Write-Host "Path: " $x.FullName
                    Write-Host "Access Time: " $x.LastAccessTime
                    Write-Host "Hash: " get-filehash $x.FullName
                    Write-Host "Matching Hash: " $h
                    Write-Host
                }
            }
        }else{
            Write-Host "Skipping " $x.FullName
            Write-Host
        }
    }
}
GlobalOptions
if($Mode -eq 'RegKey'){
    RunKeys
}elseif($Mode -eq 'TempFiles'){
    TempFiles
}else{ 
 RunKeys
 TempFiles
}