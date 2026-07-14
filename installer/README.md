# Stats Dots Installer

Run the following command from the repository root to build the Lite x64 installer:

```powershell
.\installer\Build-StatsDotsInstaller.ps1
```

The script fetches release tags from `origin`, finds the highest tag in the
`v<major>.<minor>[.<patch>]-stats-dots` format, and increments the patch
number. The existing `v1.86-stats-dots` tag is treated as version `1.86.0`,
so the next installer is version `1.86.1`.

After publishing an installer, create and push the tag printed by the script.
The following release build then increments from that tag automatically.
