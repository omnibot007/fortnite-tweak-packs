# Verified tweaks — extracted from the packs

These are the only changes from the tweak packs that are both **real** and **safe**.
Extracted here as clean, commented .reg files so you can apply them individually
without running the dangerous pack files (especially the Aphrodite .bat files,
which download unsigned executables from Discord CDN).

## Files

| File | What it does | Source | Revert |
|---|---|---|---|
| `audio-ducking-off.reg` | Stops Windows dropping game audio 80% during voice chat. Footsteps survive. | Peterbot Delay8.reg | Set `UserDuckingPreference` back to `0` |
| `power-throttling-off.reg` | Prevents background process throttling that can cause stutter when apps wake up. | ReduceInputDelay delay.reg | Delete `PowerThrottlingOff` value |
| `stickykeys-off.reg` | Prevents StickyKeys from interrupting gameplay if you hit Shift 5x. | MaxxTopia KEEP-CORE | Set `Flags` back to `510` |
| `gamedvr-off.reg` | Disables Windows Game DVR background recording. Modest stutter reduction. | ReduceInputDelay delay.reg | Set `GameDVR_Enabled` back to `1` |
| `fast-startup-off.reg` | Disables Fast Startup (keeps hibernation). Stutter/stability hygiene. | Aphrodite .bat (extracted) | Set `HiberbootEnabled` back to `1` |
| `gamebar-off.reg` | Disables Xbox Game Bar overlay. Pairs with gamedvr-off.reg. | Aphrodite .bat (extracted) | Set `UseNexusForGameBarEnabled` back to `1` |
| `accessibility-shortcuts-off.reg` | Disables StickyKeys/ToggleKeys/FilterKeys shortcuts. Prevents match-ending input interruptions. | Aphrodite .bat (extracted) | See file comments for per-key revert values |

## Usage

Double-click any .reg file to apply. Admin required for HKLM keys
(`power-throttling-off.reg`, `gamedvr-off.reg`, `fast-startup-off.reg`).
No reboot required for any of these except `fast-startup-off.reg` (takes effect
on next boot).

Or via command line:
```cmd
reg import audio-ducking-off.reg
reg import power-throttling-off.reg
reg import stickykeys-off.reg
reg import gamedvr-off.reg
reg import fast-startup-off.reg
reg import gamebar-off.reg
reg import accessibility-shortcuts-off.reg
```

## Why only 7 files?

The audit (see `../AUDIT.md`) reviewed all 36 files across 4 packs and found:
- 2 were GOOD (real + safe) — initially extracted
- 10 were MARGINAL (real but tiny effect)
- 14 were PLACEBO (no mechanism)
- 9 were HARMFUL (security reduction or damage)
- 2 were UNAUDITABLE (binary/obfuscated)

The initial extraction found 2 GOOD tweaks. A deeper read of the Aphrodite
Aim Assist .bat (748 lines, ~300+ registry changes) surfaced 4 more good
tweaks buried among the malware download and harmful changes. These are
extracted here as clean .reg files — **do not run the Aphrodite .bat files
to get these tweaks.** The .bat files download `dmv.exe` and `PowerRun.exe`
from Discord CDN. `PowerRun.exe` runs processes with SYSTEM privileges.
This is malware delivery behavior.

## What about the Aphrodite .bat files?

**Do not run them.** All three:
1. Download unsigned executables from Discord CDN to `C:\Windows\`
2. `PowerRun.exe` runs processes with SYSTEM privileges
3. `dmv.exe` is unknown — could be anything
4. Disable UAC (`EnableLUA=0`)
5. Disable Spectre/Meltdown mitigations (`FeatureSettingsOverride=3`)
6. Block driver updates via Windows Update
7. Disable the Prefetcher
8. Uninstall OneDrive without asking
9. Open a Discord invite link at the end

The good tweaks from the Aphrodite .bat are extracted in this folder.
There is no reason to ever run the .bat files themselves.

## What was NOT extracted (and why)

| Tweak | In Aphrodite .bat | Why not extracted |
|---|---|---|
| `Win32PrioritySeparation=38` | Yes | That's the **stock** Windows value. Not a tweak. |
| `NetworkThrottlingIndex=0xffffffff` | Yes | Only affects MMCSS-registered threads. Fortnite doesn't use MMCSS. Placebo. |
| `GPU Priority=8` | Yes | Not a real DXGK scheduling knob. Folklore per MaxxTopia audit. |
| TCP DelayedAck / CongestionAlgorithm / AFD buffers | Yes | TCP-only. Fortnite gameplay is UDP. Doesn't affect in-match ping. |
| TCP ServiceProvider priorities | Yes | DNS resolution ordering. Minimal effect on game ping. |
| `FeatureSettingsOverride=3` | Yes | Disables Spectre/Meltdown mitigations. Security reduction. |
| `EnableLUA=0` | Yes | Disables UAC entirely. Major security risk. |
| `EnablePrefetcher=0` | Yes | Disables Prefetcher. Can slow app launches. Not game performance. |
| `MaintenanceDisabled=1` | Yes | Windows already defers maintenance when gaming. Marginal. |
| Webcam/mic deny for UWP apps | Yes | Privacy, not performance. ~30 registry changes for this alone. |
| Narrator/accessibility disable | Yes | Most are QoL, not performance. Only the shortcut keys were extracted. |
| DWM accent color changes | Yes | Changes Windows theme colors. Not performance. |
| Push notifications off | Yes | QoL, not performance. |
| Remote Assistance off | Yes | Security, not performance. |
| OneDrive uninstall | Yes | Destructive, not performance. |
