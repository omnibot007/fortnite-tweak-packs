# Verified tweaks — extracted from the packs

These are the only changes from the tweak packs that are both **real** and **safe**.
Extracted here as clean, commented .reg files so you can apply them individually
without running the dangerous pack files.

## Files

| File | What it does | Source | Revert |
|---|---|---|---|
| `audio-ducking-off.reg` | Stops Windows dropping game audio 80% during voice chat. Footsteps survive. | Peterbot Delay8.reg | Set `UserDuckingPreference` back to `0` |
| `power-throttling-off.reg` | Prevents background process throttling that can cause stutter when apps wake up. | ReduceInputDelay delay.reg | Delete `PowerThrottlingOff` value |
| `stickykeys-off.reg` | Prevents StickyKeys from interrupting gameplay if you hit Shift 5x. | MaxxTopia KEEP-CORE (surfaced during audit) | Set `Flags` back to `510` |
| `gamedvr-off.reg` | Disables Windows Game DVR background recording. Modest stutter reduction. | ReduceInputDelay delay.reg | Set `GameDVR_Enabled` back to `1` |

## Usage

Double-click any .reg file to apply. Admin required for `power-throttling-off.reg`
and `gamedvr-off.reg` (HKLM keys). No reboot required for any of these.

Or via command line:
```cmd
reg import audio-ducking-off.reg
reg import power-throttling-off.reg
reg import stickykeys-off.reg
reg import gamedvr-off.reg
```

## Why only 4 files?

The audit (see `../AUDIT.md`) reviewed all 36 files across 4 packs:
- 2 were GOOD (real + safe)
- 10 were MARGINAL (real but tiny effect)
- 14 were PLACEBO (no mechanism)
- 9 were HARMFUL (security reduction or damage)
- 2 were UNAUDITABLE (binary/obfuscated)

Only the GOOD ones are here. The marginal ones were considered but rejected
because their effect is too small to justify the change, or they duplicate
tweaks already in the main `fortnite-latency-tweaks` repo.

## What about the Aphrodite .bat files?

**Do not run them.** All three download unsigned executables from Discord CDN
(`dmv.exe` and `PowerRun.exe`) to `C:\Windows\`. `PowerRun.exe` runs processes
with SYSTEM privileges. This is malware delivery behavior. See `../AUDIT.md`
for details.
