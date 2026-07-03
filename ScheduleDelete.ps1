param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$FilePaths,
    
    [Parameter(Mandatory=$false)]
    [switch]$Silent,
    
    [Parameter(Mandatory=$false)]
    [int]$DelayMinutes = 0
)

# Robust Logging
$logFile = Join-Path $env:TEMP "ScheduleDeleteLog.txt"
function Log-Msg($msg) { "$(Get-Date -Format 'HH:mm:ss') - $msg" | Out-File $logFile -Append }
Log-Msg "App Started. Paths: $($FilePaths -join ', ')"

try {
    # Load UI assemblies
    Add-Type -AssemblyName PresentationFramework, System.Windows.Forms, System.Drawing, WindowsBase, System.Xaml, WindowsFormsIntegration
    Log-Msg "Assemblies loaded"

    # --- Constants & Paths ---
    $appData = Join-Path $env:APPDATA "ScheduleDelete"
    $taskDir = Join-Path $appData "Tasks"
    $queueFile = Join-Path $env:TEMP "ScheduleDeleteQueue.txt"
    $mutexName = "Global\ScheduleDeleteUI_v2_2"

    if (-not (Test-Path $taskDir)) { New-Item -Path $taskDir -ItemType Directory -Force | Out-Null }

    # --- Admin Check ---
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    Log-Msg "Running as Admin: $isAdmin"

    # --- Helper: Schedule Function ---
    function Register-DeletionTask {
        param(
            [string[]]$Paths,
            [DateTime]$ExecutionTime
        )
        
        if ($Paths.Count -eq 0) { return }

        $uniqueId = [Guid]::NewGuid().ToString().Substring(0,8)
        $taskName = "DeleteScheduled_" + (Get-Date -Format "yyyyMMdd_HHmm") + "_" + $uniqueId
        $scriptPath = Join-Path $taskDir ("$taskName.ps1")
        
        # Generate a robust PS1 script for the task
        $pathsString = $Paths | ForEach-Object { "'$($_.Replace("'", "''"))'" }
        $pathsArray = $pathsString -join ",`n    "
        
        $scriptContent = @"
# Automated Deletion Script generated at $(Get-Date)
`$paths = @(
    $pathsArray
)

`$paths | ForEach-Object {
    if (Test-Path -LiteralPath `$_) {
        try {
            Remove-Item -LiteralPath `$_ -Force -Recurse -ErrorAction SilentlyContinue
        } catch {
            "`$((Get-Date).ToString()): Failed to delete `$_" | Out-File (Join-Path "`$env:TEMP" "ScheduleDelete_Errors.log") -Append
        }
    }
}

# Self-destruct script
Remove-Item -LiteralPath `$MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue
"@
        Set-Content -Path $scriptPath -Value $scriptContent -Encoding UTF8
        
        # Register the task
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
        
        # Trigger with proper boundary
        $trigger = New-ScheduledTaskTrigger -At $ExecutionTime -Once
        # Task Scheduler requires EndBoundary for some settings to work properly
        $trigger.EndBoundary = $ExecutionTime.AddHours(24).ToString("yyyy-MM-dd'T'HH:mm:ss")
        
        # Robust settings
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DeleteExpiredTaskAfter (New-TimeSpan -Minutes 1)
        
        # Principal Handling: If admin, use Highest. If not, use Limited.
        if ($isAdmin) {
            $currentPrincipal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest
        } else {
            $currentPrincipal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Limited
        }
        
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $currentPrincipal -Description "Scheduled file deletion task" -Force | Out-Null
        
        Log-Msg "Task registered: $taskName for $ExecutionTime"
        return $taskName
    }

    # --- Silent Mode Handling ---
    if ($Silent -and $DelayMinutes -gt 0) {
        $targetTime = (Get-Date).AddMinutes($DelayMinutes)
        Register-DeletionTask -Paths $FilePaths -ExecutionTime $targetTime
        Log-Msg "Silent task registered. Exiting."
        exit
    }

    # --- Single Instance Logic ---
    $mutex = New-Object System.Threading.Mutex($false, $mutexName)
    if (!$mutex.WaitOne(0)) {
        if ($FilePaths) {
            $done = $false
            for ($i=0; $i -lt 5; $i++) {
                try {
                    $FilePaths | ForEach-Object { Add-Content -LiteralPath $queueFile -Value $_ -ErrorAction Stop }
                    $done = $true; break
                } catch { Start-Sleep -Milliseconds 100 }
            }
        }
        Log-Msg "Another instance running. Paths queued. Exiting."
        exit
    }

    # --- WPF UI Design (Premium Fluent Design) ---
    $xamlString = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:wf="clr-namespace:System.Windows.Forms;assembly=System.Windows.Forms"
        Title="Schedule Delete Pro" Height="680" Width="450" 
        Background="Transparent" AllowsTransparency="True" WindowStyle="None"
        WindowStartupLocation="CenterScreen" ShowInTaskbar="True" Topmost="True">
    
    <Window.Resources>
        <Style x:Key="ModernBtn" TargetType="Button">
            <Setter Property="Background" Value="#FFD700"/>
            <Setter Property="Foreground" Value="Black"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="10">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FFFACD"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Background" Value="#444"/>
                    <Setter Property="Foreground" Value="#888"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style x:Key="GhostBtn" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#888"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="#444" BorderThickness="1" CornerRadius="8">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Foreground" Value="White"/>
                    <Setter Property="Background" Value="#333"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style x:Key="QuickBtn" TargetType="Button" BasedOn="{StaticResource GhostBtn}">
            <Setter Property="Width" Value="100"/>
            <Setter Property="Height" Value="30"/>
            <Setter Property="Margin" Value="0,0,10,0"/>
            <Setter Property="FontSize" Value="11"/>
        </Style>
    </Window.Resources>

    <Border Background="#1A1A1A" CornerRadius="20" BorderBrush="#333" BorderThickness="1.5">
        <Grid Margin="30">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <!-- Header -->
            <Grid Grid.Row="0" Margin="0,0,0,25">
                <StackPanel Orientation="Horizontal">
                    <TextBlock Text="Schedule" Foreground="Gold" FontSize="26" FontWeight="Bold"/>
                    <TextBlock Text=" Delete Pro" Foreground="White" FontSize="26" FontWeight="Light"/>
                </StackPanel>
                <Button Name="CloseBtn" Content="✕" Background="Transparent" Foreground="Gray" BorderThickness="0" HorizontalAlignment="Right" VerticalAlignment="Top" FontSize="18" Padding="5"/>
            </Grid>

            <!-- File List Section -->
            <Grid Grid.Row="1" Margin="0,0,0,10">
                <TextBlock Text="SELECTED ITEMS" Foreground="#666" FontSize="10" FontWeight="Black" VerticalAlignment="Center"/>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
                    <Button Name="AddBtn" Style="{StaticResource GhostBtn}" Content="+ Add" Width="60" Height="22" FontSize="9" Margin="0,0,5,0"/>
                    <Button Name="ClearBtn" Style="{StaticResource GhostBtn}" Content="Clear All" Width="70" Height="22" FontSize="9"/>
                </StackPanel>
            </Grid>
            
            <Border Grid.Row="2" Background="#222" CornerRadius="12" Padding="8" Margin="0,0,0,20">
                <ListBox Name="FileListBox" Background="Transparent" BorderThickness="0" Foreground="#DDD" 
                         ScrollViewer.HorizontalScrollBarVisibility="Disabled" AllowDrop="True">
                    <ListBox.ItemTemplate>
                        <DataTemplate>
                            <Grid Margin="2">
                                <TextBlock Text="{Binding}" TextTrimming="CharacterEllipsis" FontSize="13"/>
                            </Grid>
                        </DataTemplate>
                    </ListBox.ItemTemplate>
                </ListBox>
            </Border>

            <!-- Date/Time Section -->
            <StackPanel Grid.Row="3" Margin="0,0,0,10">
                <TextBlock Text="EXECUTION TIME" Foreground="#666" FontSize="10" FontWeight="Black"/>
            </StackPanel>
            
            <WindowsFormsHost Grid.Row="4" Height="42" Margin="0,0,0,15">
                <wf:DateTimePicker x:Name="WFDateTimePicker" />
            </WindowsFormsHost>

            <!-- Quick Selection -->
            <StackPanel Grid.Row="5" Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,0,0,25">
                <Button Name="BtnPlus10m" Style="{StaticResource QuickBtn}" Content="+10 Minutes"/>
                <Button Name="BtnPlus1h" Style="{StaticResource QuickBtn}" Content="+1 Hour"/>
                <Button Name="BtnPlus1d" Style="{StaticResource QuickBtn}" Content="+24 Hours" Margin="0"/>
            </StackPanel>

            <!-- Actions -->
            <Button Grid.Row="6" Name="ScheduleBtn" Style="{StaticResource ModernBtn}" Content="Schedule Deletion Task" Height="55" FontSize="15"/>
            <TextBlock Name="StatusLabel" Grid.Row="7" Text="Ready to schedule" Foreground="#444" HorizontalAlignment="Center" Margin="0,15,0,0" FontSize="11"/>
        </Grid>
    </Border>
</Window>
"@

    Log-Msg "Parsing XAML"
    $window = [Windows.Markup.XamlReader]::Parse($xamlString)

    # --- UI Logic Binding ---
    $fileListBox = $window.FindName("FileListBox")
    $scheduleBtn = $window.FindName("ScheduleBtn")
    $closeBtn = $window.FindName("CloseBtn")
    $addBtn = $window.FindName("AddBtn")
    $clearBtn = $window.FindName("ClearBtn")
    $statusLabel = $window.FindName("StatusLabel")
    $dtPicker = $window.FindName("WFDateTimePicker")
    
    $btn10m = $window.FindName("BtnPlus10m")
    $btn1h = $window.FindName("BtnPlus1h")
    $btn1d = $window.FindName("BtnPlus1d")

    # WinForms DateTimePicker styling
    $dtPicker.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
    $dtPicker.CustomFormat = "MMMM dd, yyyy  at  HH:mm"
    $dtPicker.Value = (Get-Date).AddHours(1)
    $dtPicker.Font = New-Object System.Drawing.Font("Segoe UI", 11)

    # Initialize file list
    $allPaths = New-Object System.Collections.ObjectModel.ObservableCollection[string]
    function Add-Path($p) {
        if ($p -and (Test-Path -LiteralPath $p) -and -not $allPaths.Contains($p)) {
            $allPaths.Add($p)
            Log-Msg "Added path: $p"
        }
    }

    if ($FilePaths) { $FilePaths | ForEach-Object { Add-Path $_ } }
    $fileListBox.ItemsSource = $allPaths

    # Events
    $window.Add_MouseLeftButtonDown({ $window.DragMove() })
    $closeBtn.Add_Click({ $window.Close() })
    $clearBtn.Add_Click({ $allPaths.Clear() })
    
    $btn10m.Add_Click({ $dtPicker.Value = (Get-Date).AddMinutes(10) })
    $btn1h.Add_Click({ $dtPicker.Value = (Get-Date).AddHours(1) })
    $btn1d.Add_Click({ $dtPicker.Value = (Get-Date).AddDays(1) })

    $addBtn.Add_Click({
        $dialog = New-Object System.Windows.Forms.OpenFileDialog
        $dialog.Multiselect = $true
        $dialog.Title = "Select Files to Schedule"
        if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $dialog.FileNames | ForEach-Object { Add-Path $_ }
        }
    })

    # Drag & Drop support
    $fileListBox.Add_Drop({
        param($s, $e)
        if ($e.Data.GetDataPresent([System.Windows.DataFormats]::FileDrop)) {
            $files = $e.Data.GetData([System.Windows.DataFormats]::FileDrop)
            foreach ($f in $files) { Add-Path $f }
        }
    })

    # Path Queue Timer
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 500
    $timer.Add_Tick({
        if (Test-Path $queueFile) {
            try {
                $queuedPaths = Get-Content $queueFile -ErrorAction SilentlyContinue
                Remove-Item $queueFile -ErrorAction SilentlyContinue
                foreach ($p in $queuedPaths) { Add-Path $p }
            } catch {}
        }
    })
    $timer.Start()

    # Schedule Logic
    $scheduleBtn.Add_Click({
        if ($allPaths.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("Please add at least one file to schedule.", "Empty List")
            return
        }

        $targetTime = $dtPicker.Value
        if ($targetTime -le (Get-Date)) {
            $targetTime = (Get-Date).AddMinutes(1) # Fallback to 1 min if user set past
            $dtPicker.Value = $targetTime
        }

        $statusLabel.Text = "REGISTERING TASK..."
        $statusLabel.Foreground = [System.Windows.Media.Brushes]::Gold
        $scheduleBtn.IsEnabled = $false

        try {
            Register-DeletionTask -Paths ($allPaths | ForEach-Object {$_}) -ExecutionTime $targetTime
            [System.Windows.Forms.MessageBox]::Show("Deletion scheduled successfully for $($targetTime.ToString('f'))", "Task Active")
            $window.Close()
        } catch {
            Log-Msg "Schedule Error: $($_.Exception.Message)"
            $statusLabel.Text = "FAILED TO SCHEDULE"
            $statusLabel.Foreground = [System.Windows.Media.Brushes]::Red
            $scheduleBtn.IsEnabled = $true
            [System.Windows.Forms.MessageBox]::Show("Failed to register task: $($_.Exception.Message)", "Error")
        }
    })

    $window.Add_Closed({
        $timer.Stop()
        if ($mutex) {
            $mutex.ReleaseMutex()
            $mutex.Dispose()
        }
        if (Test-Path $queueFile) { Remove-Item $queueFile -ErrorAction SilentlyContinue }
    })

    # Bring to front
    Log-Msg "Showing window"
    $window.Show()
    $window.Activate()
    $window.Topmost = $false
    
    # WPF loop
    [System.Windows.Threading.Dispatcher]::Run() | Out-Null

} catch {
    Log-Msg "FATAL ERROR: $($_.Exception.Message)"
    [System.Windows.Forms.MessageBox]::Show("Fatal error: $($_.Exception.Message)", "ScheduleDelete Error")
}
