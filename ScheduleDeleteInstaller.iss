; Inno Setup Script for ScheduleDelete v2.4
; Upgraded for WPF UI and Robust Task Scheduling

[Setup]
AppId={{92b9029b-0eed-4ef6-833a-c3da226ba3e5}
AppName=ScheduleDelete
AppVersion=2.5.0
DefaultDirName={commonpf}\ScheduleDelete
DefaultGroupName=ScheduleDelete
UninstallDisplayIcon={app}\ScheduleDelete.bat
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
OutputBaseFilename=ScheduleDelete_Pro_v2.5_Setup
WizardStyle=modern
Uninstallable=yes

[Files]
Source: "ScheduleDelete.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "ScheduleDelete.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "schedule_delete_icon.png"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
; Clean up potential legacy keys from previous versions
Root: HKCR; Subkey: "*\shell\ScheduleDelete"; Flags: deletekey uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete"; Flags: deletekey uninsdeletekey

; Context Menu setup for Files
Root: HKCR; Subkey: "*\shell\ScheduleDelete"; ValueType: string; ValueName: "MUIVerb"; ValueData: "Schedule Delete..."; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\ScheduleDelete"; ValueType: string; ValueName: "Icon"; ValueData: "shell32.dll,27"
Root: HKCR; Subkey: "*\shell\ScheduleDelete"; ValueType: string; ValueName: "SubCommands"; ValueData: ""

; Sub-commands for File
Root: HKCR; Subkey: "*\shell\ScheduleDelete\shell\open"; ValueType: string; ValueName: ""; ValueData: "Open Scheduler UI"
Root: HKCR; Subkey: "*\shell\ScheduleDelete\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ScheduleDelete.bat"" ""%1"""

Root: HKCR; Subkey: "*\shell\ScheduleDelete\shell\1hour"; ValueType: string; ValueName: ""; ValueData: "Delete in 1 Hour"
Root: HKCR; Subkey: "*\shell\ScheduleDelete\shell\1hour\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ScheduleDelete.bat"" -Silent -DelayMinutes 60 ""%1"""

Root: HKCR; Subkey: "*\shell\ScheduleDelete\shell\24hours"; ValueType: string; ValueName: ""; ValueData: "Delete in 24 Hours"
Root: HKCR; Subkey: "*\shell\ScheduleDelete\shell\24hours\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ScheduleDelete.bat"" -Silent -DelayMinutes 1440 ""%1"""

; Context Menu setup for Directories
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete"; ValueType: string; ValueName: "MUIVerb"; ValueData: "Schedule Delete..."; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete"; ValueType: string; ValueName: "Icon"; ValueData: "shell32.dll,27"
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete"; ValueType: string; ValueName: "SubCommands"; ValueData: ""

; Sub-commands for Directory
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete\shell\open"; ValueType: string; ValueName: ""; ValueData: "Open Scheduler UI"
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ScheduleDelete.bat"" ""%1"""

Root: HKCR; Subkey: "Directory\shell\ScheduleDelete\shell\1hour"; ValueType: string; ValueName: ""; ValueData: "Delete in 1 Hour"
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete\shell\1hour\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ScheduleDelete.bat"" -Silent -DelayMinutes 60 ""%1"""

Root: HKCR; Subkey: "Directory\shell\ScheduleDelete\shell\24hours"; ValueType: string; ValueName: ""; ValueData: "Delete in 24 Hours"
Root: HKCR; Subkey: "Directory\shell\ScheduleDelete\shell\24hours\command"; ValueType: string; ValueName: ""; ValueData: """{app}\ScheduleDelete.bat"" -Silent -DelayMinutes 1440 ""%1"""

[Icons]
Name: "{group}\ScheduleDelete"; Filename: "{app}\ScheduleDelete.bat"
Name: "{commondesktop}\ScheduleDelete"; Filename: "{app}\ScheduleDelete.bat"

[Run]
Description: "Launch ScheduleDelete"; Flags: postinstall nowait skipifsilent; Filename: "{app}\ScheduleDelete.bat"
