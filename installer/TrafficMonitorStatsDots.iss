#define AppName "TrafficMonitor (Stats Dots)"
#define AppVersion "1.86-stats-dots"
#define AppExeName "TrafficMonitor.exe"

[Setup]
AppId={{4FC41EA6-68ED-461F-9636-552A5AE4772B}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=zhongyang219
AppPublisherURL=https://github.com/zhongyang219/TrafficMonitor
DefaultDirName={autopf}\TrafficMonitor Stats Dots
DefaultGroupName=TrafficMonitor Stats Dots
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\{#AppExeName}
OutputDir=..\dist
OutputBaseFilename=TrafficMonitor_1.86_StatsDots_x64_Setup
SetupIconFile=..\TrafficMonitor\res\TrafficMonitor.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\Bin\x64\Release (lite)\TrafficMonitor.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Bin\x64\Release\plugins\PluginDemo.dll"; DestDir: "{app}\plugins"; Flags: ignoreversion
Source: "..\TrafficMonitor\skins\*"; DestDir: "{app}\skins"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\TrafficMonitor\language\*"; DestDir: "{app}\language"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\Help.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Help_en-us.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "redist\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\TrafficMonitor"; Filename: "{app}\{#AppExeName}"
Name: "{group}\Uninstall TrafficMonitor"; Filename: "{uninstallexe}"

[Run]
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Microsoft Visual C++ Runtime..."; Flags: waituntilterminated
Filename: "{app}\{#AppExeName}"; Description: "Launch TrafficMonitor"; Flags: nowait postinstall skipifsilent
