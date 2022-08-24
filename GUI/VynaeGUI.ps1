# Vynae GUI Option


# GUI Init
function GuiInit{

    # Global Form creation
    Add-Type -assembly System.Windows.Forms
    $global:mainform = New-Object System.Windows.Forms.Form

    # Form Settings
    $mainform.Text ="Vynae Process Exploration GUI"
    $mainform.Width = 1200
    $mainform.Height = 900
    $mainform.MaximizeBox = $false
    $mainform.MinimizeBox = $false
    $mainform.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
}

# Gui Start
function StartForm{

    # Display Form
    $mainform.ShowDialog()

}


# Application MainBody 
function Proc_Get{

    # Create a label for process info
    $ProcLabel = New-Object System.Windows.Forms.Label
    $ProcLabel.Text = "Process Information"

    # Place Label
    $ProcLabel.Location = New-Object System.Drawing.Point(5,0)

    # Label Settings
    $ProcLabel.AutoSize = $true

    # Add to main form
    $mainform.Controls.Add($ProcLabel)

    # Create a list of processes 
    $global:ProcList = New-Object System.Windows.Forms.datagridview

    # Process list Settings
    $ProcList.Width = $mainform.Width * .96
    $ProcList.Height = $mainform.Height * .40
    $ProcList.ReadOnly = $true
    # $ProcList.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect

    # Create Data Array of Process Information
    $ProcData = Get-Ciminstance CIM_Process | Select Name, ProcessID, ParentProcessID, ExecutablePath, CreationDate
    $ProcDataArray = New-Object System.Collections.ArrayList
    $ProcDataArray.AddRange(@($ProcData))

    # Add array as data source for Data Grid View Object
    $ProcList.DataSource = $ProcDataArray

    # Resize the Data Grid columns to fill the object space
    $ProcList.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

    # Place List 
    $ProcList.Location = New-Object System.Drawing.Point(10,50)

    # Add to Form
    $mainform.Controls.Add($ProcList)

    # Add a search bar 
    $global:ProcSearch = New-Object System.Windows.Forms.TextBox
    $ProcSearch.Text = "filter..."
    $ProcSearch.Location = New-Object System.Drawing.Point(100,23)
    $ProcSearch.Width = $mainform.Width * .80
    $ProcSearch.Height = 10
    $mainform.Controls.Add($ProcSearch)


    # Add a search button
    $SearchButton = New-Object System.Windows.Forms.Button
    $SearchButton.Text = "Filter"
    $SearchButton.AutoSize = $true
    $SearchButton.Location = New-Object System.Drawing.Point(10,20)
    $mainform.Controls.Add($SearchButton)

    # Filter stuff
    $SearchButton.Add_Click({
        $out = $ProcSearch.Text -split '='
        write-host $out[0], $out[1]
        if($out[0] -eq "Name"){
            $ProcList.DataSource = $null
            $Proclist.Rows.Clear()
            $ProcData = Get-Ciminstance CIM_Process | ? Name -match $out[1] | Select Name, ProcessID, ParentProcessID, ExecutablePath, CreationDate
            $ProcDataArray = New-Object System.Collections.ArrayList
            $ProcDataArray.AddRange(@($ProcData))
            $ProcList.DataSource = $ProcDataArray
        }elseif($out[0] -eq "ID"){
            $ProcList.DataSource = $null
            $Proclist.Rows.Clear()
            $ProcData = Get-Ciminstance CIM_Process | ? ProcessID -eq $out[1] | Select Name, ProcessID, ParentProcessID, ExecutablePath, CreationDate
            $ProcDataArray = New-Object System.Collections.ArrayList
            $ProcDataArray.AddRange(@($ProcData))
            $ProcList.DataSource = $ProcDataArray
        }elseif($out[0] -eq "ParentID"){
            $ProcList.DataSource = $null
            $Proclist.Rows.Clear()
            $ProcData = Get-Ciminstance CIM_Process | ? ParentProcessID -eq $out[1] | Select Name, ProcessID, ParentProcessID, ExecutablePath, CreationDate
            $ProcDataArray = New-Object System.Collections.ArrayList
            $ProcDataArray.AddRange(@($ProcData))
            $ProcList.DataSource = $ProcDataArray
        }elseif($out[0] -eq "Trace"){
            $global:GetParent = Get-Ciminstance CIM_Process | ? ProcessID -eq $out[1]
            $ParentArray =@()
            $ParentArray += $GetParent | Select Name, ProcessID, ParentProcessID, ExecutablePath, CreationDate
            $quit = $false
            While($quit -ne $true){
                # Wrap in if to test if the parent exists and is not 0
                if((Get-Ciminstance CIM_Process | ? ProcessID -eq $GetParent.ParentProcessID) -And $GetParent.ParentProcessID -ne 0){
                    # Get the parent ID
                    $ParentID = Get-Ciminstance CIM_Process | ? ProcessID -eq $GetParent.ParentProcessID | Select Name, ProcessID, ParentProcessID, ExecutablePath, CreationDate
                    # store the ID
                    $ParentArray += $ParentID
                    # Set Get-Parent to the new process ID 
                    $GetParent = $ParentID.ProcessID
                    # Print for testing
                    write-host $ParentArray

                    # Reset DataGridView
                    $ProcList.DataSource = $null
                    $ProcList.Rows.Clear()

                    # Add new Data Source
                    $ProcDataArray = New-Object System.Collections.ArrayList
                    $ProcDataArray.AddRange(@($ParentArray))
                    $ProcList.DataSource = $ProcDataArray
                }else{
                    Clear-Variable ParentArray
                    $quit = $True
                }
            }
        }else{
            $ProcData = Get-Ciminstance CIM_Process | Select Name, ProcessID, ParentProcessID, ExecutablePath, CreationDate
            $ProcDataArray = New-Object System.Collections.ArrayList
            $ProcDataArray.AddRange(@($ProcData))
            $ProcList.DataSource = $ProcDataArray
        }
        })


    # Create Buttons [rename to procbutton]
    $DumpButton = New-Object System.Windows.Forms.Button

    # Highlighted Process Information

    # Create title label
    $DetailsLabel = New-Object System.Windows.Forms.button
    $DetailsLabel.Text = "Process Details"
    $DetailsLabel.AutoSize = $true

    # Create Info Labels
    $NameLabel = New-Object System.Windows.Forms.Label
    $IdLabel = New-Object System.Windows.Forms.Label
    $ParentID = New-Object System.Windows.Forms.Label
    $ParentName = New-Object System.Windows.Forms.Label
    $CreationDate = New-Object System.Windows.Forms.Label
    $Hash = New-Object System.Windows.Forms.Label
    $Location = New-Object System.Windows.Forms.Label
    $CommandLine = New-Object System.Windows.Forms.Label

    # Create Value lables
    $global:NameLabelValue = New-Object System.Windows.Forms.Label
    $global:IDLabelValue = New-Object System.Windows.Forms.Label
    $global:ParentIDValue = New-Object System.Windows.Forms.Label
    $global:ParentNameValue = New-Object System.Windows.Forms.Label
    $global:CreationDateValue = New-Object System.Windows.Forms.Label
    $global:HashValue = New-Object System.Windows.Forms.Label
    $global:LocationValue = New-Object System.Windows.Forms.Label
    $global:CommandLineValue = New-Object System.Windows.Forms.Label

    # Init Labels
    $NameLabel.Text = "Name:"
    $NameLabel.AutoSize = $true
    $NameLabel.Location = New-Object System.Drawing.Point(10, 450)
    $mainform.Controls.Add($NameLabel)

    $NameLabelValue.Text = ""
    $NameLabelValue.AutoSize = $true
    $NameLabelValue.MaximumSize = New-Object System.Drawing.Point(135,0)
    $NameLabelValue.Location = New-Object System.Drawing.Point(50, 450)
    $mainform.Controls.Add($NameLabelValue)

    $IDLabel.Text = "Process ID:"
    $IDLabel.AutoSize = $true
    $IDLabel.Location = New-Object System.Drawing.Point(10, 490)
    $mainform.Controls.Add($IDLabel)

    $IDLabelValue.Text = ""
    $IDLabelValue.AutoSize = $true
    $IDLabelValue.Location = New-Object System.Drawing.Point(75, 490)
    $mainform.Controls.Add($IDLabelValue)

    $ParentID.Text = "Parent ID:"
    $ParentID.AutoSize = $true
    $PArentID.Location = New-Object System.Drawing.Point(200, 490)
    $mainform.Controls.Add($ParentID)

    $ParentIDValue.Text = ""
    $ParentIDValue.AutoSize = $true
    $PArentIDValue.Location = New-Object System.Drawing.Point(255, 490)
    $mainform.Controls.Add($ParentIDValue)

    $ParentName.Text = "Parent Name:"
    $ParentName.AutoSize = $true
    $ParentName.Location = New-Object System.Drawing.Point(200, 450)
    $mainform.Controls.Add($ParentName)

    $ParentNameValue.Text = ""
    $ParentNameValue.AutoSize = $true
    $ParentNameValue.Location = New-Object System.Drawing.Point(280, 450)
    $mainform.Controls.Add($ParentNameValue)

    $CreationDate.Text = "Creation Date:"
    $CreationDate.AutoSize = $true
    $CreationDate.Location = New-Object System.Drawing.Point(10, 530)
    $mainform.Controls.Add($CreationDate)

    $CreationDateValue.Text = ""
    $CreationDateValue.AutoSize = $true
    $CreationDateValue.Location = New-Object System.Drawing.Point(90, 530)
    $mainform.Controls.Add($CreationDateValue)

    $Hash.Text = "Hash:"
    $Hash.AutoSize = $true
    $Hash.Location = New-Object System.Drawing.Point(10, 610)
    $mainform.Controls.Add($Hash)

    $HashValue.Text = ""
    $HashValue.AutoSize = $true
    $HashValue.Location = New-Object System.Drawing.Point(55, 610)
    $mainform.Controls.Add($HashValue)

    $Location.Text = "File Location:"
    $Location.AutoSize = $true
    $Location.Location = New-Object System.Drawing.Point(10, 570)
    $mainform.Controls.Add($Location)

    $LocationValue.Text = ""
    $LocationValue.MaximumSize = New-Object System.Drawing.Point(275,0)
    $LocationValue.AutoSize = $true
    $LocationValue.Location = New-Object System.Drawing.Point(80, 570)
    $mainform.Controls.Add($LocationValue)

    $CommandLine.Text = "Command Line Arguments:"
    $CommandLine.AutoSize = $true
    $CommandLine.Location = New-Object System.Drawing.Point(10, 650)
    $mainform.Controls.Add($CommandLine)

    $CommandLineValue.Text = ""
    $CommandLineValue.AutoSize = $true
    $CommandLineValue.MaximumSize = New-Object System.Drawing.Point(350,0)
    $CommandLineValue.Location = New-Object System.Drawing.Point(10, 670)
    $mainform.Controls.Add($CommandLineValue)

    # Create Label 
    $NetLabel = New-Object System.Windows.Forms.Label
    $NetLabel.Text = "Network Connections"
    $NetLabel.AutoSize = $true
    $NetLabel.Location = New-Object System.Drawing.Point(600,420)
    $mainform.Controls.Add($NetLabel)

    # Create ListView
    $global:NetList = New-Object System.Windows.Forms.datagridview
    $NetList.ReadOnly = $True
    $NetList.Visible = $true

    # Place List
    $NetList.Location = New-Object System.Drawing.Point(600, 450)
    $NetList.Width = $mainform.Width * .45
    $NetList.Height = $mainform.Height * .35
    $mainform.Controls.Add($NetList)


    # Place Button & Create Button_Clicked event
    $DetailsLabel.Location = New-Object System.Drawing.Point(10, 420)
    $mainform.Controls.Add($DetailsLabel)
    $DetailsLabel.Add_Click(
    {
        $P = Get-Ciminstance CIM_Process | ? ProcessID -eq $ProcList.CurrentRow.Cells[1].Value 
        $PP = Get-Ciminstance CIM_Process | ? ProcessID -eq $P.ParentProcessID 
        $H = Get-FileHash -Algorithm MD5 $P.ExecutablePath
        $NameLabelValue.Text = $P.Name
        $IDLabelValue.Text = $P.ProcessID
        $ParentIDValue.Text = $P.ParentProcessID
        $ParentNameValue.Text = $PP.Name
        $CreationDateValue.Text = $P.CreationDate
        $LocationValue.Text = $P.ExecutablePath
        $HashValue.Text = $H.Hash
        $CommandLineValue.Text = $P.CommandLine

        # Pass to Network function
        NetDisplay($P.ProcessID)
        # write-host $ProcList.SelectedCells.Value
        write-host $ProcList.CurrentRow.Cells[1].Value
        })

}

# Function to create and display the Network Information in a ListView
function NetDisplay($ProcID){

    # Check if Network info exists
    if(Get-NetTCPConnection | ? OwningProcess -eq $ProcID){

        # Create Data Array of Network Information
        $NetData = get-nettcpconnection | ? OwningProcess -eq $ProcID | Select LocalAddress, LocalPort, RemoteAddress, RemotePort, State
        $NetDataArray = New-Object System.Collections.ArrayList
        write-host $NetData
        $NetDataArray.AddRange(@($NetData))

        # Add array as data source for Data Grid View Object
        $NetList.DataSource = $NetDataArray

        # Resize the Data Grid columns to fill the object space
        $NetList.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
        }else{

            # Clear Data Grid if no network information
            $NetList.DataSource = $null
            $NetList.Rows.Clear()
        }

}


# Call Form Creator
GuiInit

# Call Process Information Creator 
Proc_Get

# Start Form
StartForm