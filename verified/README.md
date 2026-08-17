# Verified tweaks — extracted from the packs + MaxxTopia catalog

These are tweaks that are both **real** and **safe**. The first 7 were extracted
from the tweak packs (audited in `../AUDIT.md`). The remaining 2 were sourced
from MaxxTopia's independent efficacy catalog (100 tweaks, 16 measured-tier)
because the packs themselves are exhausted — only 6 good tweaks from 36 files.

## Files

### From the packs

| File | What it does | Source | Revert |
|---|---|---|---|
| `audio-ducking-off.reg` | Stops Windows dropping game audio 80% during voice chat. Footsteps survive. | Peterbot Delay8.reg | Set `UserDuckingPreference` back to `0` |
| `power-throttling-off.reg` | Prevents background process throttling that can cause stutter when apps wake up. | ReduceInputDelay delay.reg | Delete `PowerThrottlingOff` value |
| `stickykeys-off.reg` | Prevents StickyKeys from interrupting gameplay if you hit Shift 5x. | MaxxTopia KEEP-CORE | Set `Flags` back to `510` |
| `gamedvr-off.reg` | Disables Windows Game DVR background recording. Modest stutter reduction. | ReduceInputDelay delay.reg | Set `GameDVR_Enabled` back to `1` |
| `fast-startup-off.reg` | Disables Fast Startup (keeps hibernation). Stutter/stability hygiene. | Aphrodite .bat (extracted) | Set `HiberbootEnabled` back to `1` |
| `gamebar-off.reg` | Disables Xbox Game Bar overlay. Pairs with gamedvr-off.reg. | Aphrodite .bat (extracted) | Set `UseNexusForGameBarEnabled` back to `1` |
| `accessibility-shortcuts-off.reg` | Disables StickyKeys/ToggleKeys/FilterKeys shortcuts. Prevents match-ending input interruptions. | Aphrodite .bat (extracted) | See file comments for per-key revert values |

### From MaxxTopia catalog (packs exhausted, pulling from independent audit)

| File | What it does | Source | Revert |
|---|---|---|---|
| `usb-power-mgmt-off.reg` | Disables USB selective-suspend. Removes 1-3ms wake stalls when USB controller needed mid-frame. | MaxxTopia `process.usb-power-mgmt.disable` (mechanism tier) | Delete `EnhancedPowerManagementEnabled` value |
| `hid-power-mgmt-off.reg` | Disables HID power management for mouse/keyboard/controllers. Companion to USB tweak. | MaxxTopia `process.hid-power-mgmt.disable` (mechanism tier) | Delete `EnhancedPowerManagementEnabled` value |

## Already applied on this machine (no .reg needed)

These MaxxTopia measured-tier tweaks were verified as already set:

| Tweak | MaxxTopia ID | Current value | How it got set |
|---|---|---|---|
| Mouse acceleration off | `ui.mouse.disable-acceleration` | `MouseSpeed=0, MouseThreshold1=0, MouseThreshold2=0` | Already off (user setting) |
| Fortnite priority High | `process.fortnite.priority-high` | `CpuPriorityClass=3, IoPriority=3` | IFEO entry already exists |
| MSI mode on GPU | `process.msi-mode.gpu-nic-audio` | `MSISupported=1` on Quadro T1000 | Already set by driver |
| MSI mode on Wi-Fi | same | `MSISupported=1` on AX201 | Already set by driver |
| MSI mode on Ethernet | same | `MSISupported=1` on I219-V | Already set by driver |
| Audio ducking off | `audio.comms-ducking.disable` | `UserDuckingPreference=3` | Applied via this repo |
| StickyKeys off | `ui.sticky-keys.disable` | `Flags=506` | Applied via this repo |
| Power throttling off | `process.power-throttling.disable` | `PowerThrottlingOff=1` | Applied via this repo |
| Fast Startup off | `power.fast-startup.disable` | (pending) | Extracted, not yet applied |
| GameDVR off | `ui.gamedvr.disable` | `GameDVR_Enabled=0` | Already in latency-tweaks repo |

## Not applicable to this machine

| Tweak | MaxxTopia ID | Why not |
|---|---|---|
| Maximize display refresh rate | `display.refresh.maximize` | Panel is 60Hz — already at max |
| NIC EEE / Green Ethernet off | `net.nic.eee-powersave.disable` | Intel AX201 Wi-Fi doesn't expose EEE properties (EEE is a wired Ethernet feature) |
| RGB control apps autostart disable | `peripherals.rgb-control-apps.autostart-disable` | ThinkPad has no RGB lighting |
| NVIDIA Profile Inspector profile | `nvidia.nvpi.fortnite-profile` | Requires NVPI tool, not a .reg file |
| Audio sample rate 48kHz | `audio.sample-rate.match` | Advisory only — must be set in Sound control panel (Playback > Properties > Advanced > 24-bit 48000 Hz). Cannot be set via .reg. |
| CS2 autoexec | `cs2.autoexec.optimize` | Not Fortnite |
| Apex videoconfig | `apex.videoconfig.optimize` | Not Fortnite |

## Usage

Double-click any .reg file to apply. Admin required for HKLM keys
(`power-throttling-off.reg`, `gamedvr-off.reg`, `fast-startup-off.reg`,
`usb-power-mgmt-off.reg`, `hid-power-mgmt-off.reg`).
Reboot required for `fast-startup-off.reg`, `usb-power-mgmt-off.reg`,
`hid-power-mgmt-off.reg`.

Or via command line:
```cmd
reg import audio-ducking-off.reg
reg import power-throttling-off.reg
reg import stickykeys-off.reg
reg import gamedvr-off.reg
reg import fast-startup-off.reg
reg import gamebar-off.reg
reg import accessibility-shortcuts-off.reg
reg import usb-power-mgmt-off.reg
reg import hid-power-mgmt-off.reg
```

## How we got here

1. **Audited all 36 files** across 4 tweak packs (Aphrodite, Peterbot, ReduceInputDelay, BloomReducer). See `../AUDIT.md`.
2. **Extracted 7 good tweaks** from the packs as clean .reg files. The packs are 5.6% good by file count, but the Aphrodite .bat files contained 4 more good tweaks buried among malware downloads and harmful changes.
3. **Exhausted the packs** — no more good tweaks to extract from them.
4. **Pulled from MaxxTopia's catalog** (100 tweaks, 16 measured-tier) to find additional good tweaks not in the packs.
5. **Verified current machine state** — most MaxxTopia measured-tier tweaks are already applied. Only USB and HID power management were not set.
6. **Created 2 more .reg files** from MaxxTopia's catalog.

Total: **9 verified .reg files** (7 from packs + 2 from MaxxTopia).

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
