# Fortnite Tweak Packs

Collection of Fortnite "FPS booster" / "input delay reducer" tweak packs found in the wild.
Preserved here for archival, audit, and research purposes.

## WARNING — READ BEFORE RUNNING ANYTHING

**These packs were collected from YouTube tutorials and community downloads. Most contain
changes that are security-reducing, placebo, or potentially harmful. None have been tested
on the target machine. Approach with caution.**

Known risks by pack:

| Pack | Risk level | What it does |
|---|---|---|
| **Peterbot** | **HIGH** | Disables UAC entirely (`EnableLUA=0`), disables Windows Update, hides sleep/hibernate options, adds a fake legal notice on login. Several keys are Windows 9x-era fakes (`VxD\BIOS`) or placebo (`Games\GameFluidity`). |
| **Aphrodite** | **HIGH** | The "Zero Delay" .bat is 1.7MB of obfuscated/encoded content — cannot be audited by reading. The "Aim Assist Enhancing" name suggests game-behavior modification (anti-cheat risk). All three .bat files attempt to create restore points and modify system state. |
| **BloomReducer** | **MEDIUM** | Contains `InternetBooster_4.11.4.0.exe` — a binary that cannot be audited without running it. Claims to boost internet speed. Likely modifies network settings. |
| **ReduceInputDelay** | **MEDIUM** | Mix of real and placebo registry tweaks. Some keys (`Win32PrioritySeparation=0xfff55555` in `delayy.reg`) are invalid values. Others (`MSMQ\Parameters\TCPNoDelay`) target the wrong registry path for TCP tuning. |

## Repository structure

```
fortnite-tweak-packs/
├── Aphrodite/
│   ├── Aphrodite_Zero_Delay.bat              (1.7MB, obfuscated)
│   ├── Aphrodite_Aim_Assist_Enhancing.bat    (59KB)
│   └── Aphrodite_Shotgun_Registration.bat    (13KB)
├── Peterbot/
│   ├── Delay1.reg                            (disables UAC — DANGEROUS)
│   ├── Delay2.reg                            (power profile events)
│   ├── Delay3.reg                            (timer coalescing off)
│   ├── Delay4.reg                            (Peernet P2P)
│   ├── Delay5.reg                            (UAC disabled flag)
│   ├── Delay6.reg                            (fake legal notice on login)
│   ├── Delay7.reg                            (delayed desktop switch timeout)
│   ├── Delay8.reg                            (audio ducking off — legit)
│   ├── Delay9.reg                            (hides sleep + hibernate)
│   ├── Delay10.reg                           (disables Windows Update)
│   ├── Delay11.reg                           (Explorer: show hidden files, extensions)
│   ├── Delay12.reg                           (folder type)
│   ├── Delay13.reg                           (AppHost content evaluation)
│   ├── Delay14.reg                           (reliability timestamp)
│   ├── Delay15.reg                           (WPF/Avalon graphics)
│   ├── Delay16.reg                           (GPU VRR driver settings)
│   ├── Delay17.reg                           (NVIDIA pipe optimization)
│   ├── Delay18.reg                           (VxD BIOS — FAKE Win9x keys)
│   ├── Delay19.reg                           (Games GameFluidity — likely placebo)
│   ├── Delay20.reg                           (NTFS tweaks: disable 8.3, last access)
│   ├── Delay21.reg                           (Intel GMM segment size)
│   ├── Delay22.reg                           (VsyncIdleTimeout=0, HAGS)
│   └── Delay23.reg                           (MMCSS Games/Audio affinity)
├── ReduceInputDelay/
│   ├── 2_Ping_Reduction_Strong.reg           (NetworkThrottlingIndex=0xffffffff)
│   ├── Controller_Tweaks_2.0.reg             (Win32PrioritySeparation=0x28)
│   ├── delay.reg                             (MMCSS, GameDVR off, FSE, timeouts)
│   ├── delayy.reg                            (Win32PrioritySeparation=0xfff55555 — INVALID)
│   ├── fcshotgun.reg                         (DNS/TCP provider priorities)
│   ├── FPS.reg                               (DisplayPostProcessing MMCSS task)
│   ├── OverallShotGun.v1 (1).reg             (same as fcshotgun.reg)
│   ├── ReduceInputDelay.reg                  (Win32PrioritySeparation=0x28, FeatureSettings)
│   └── shakey_best_input.reg                 (MSMQ TCPNoDelay — wrong path)
└── BloomReducer/
    └── InternetBooster_4.11.4.0.exe          (binary — cannot audit)
```

## Per-file analysis

### Peterbot (23 .reg files)

| File | What it changes | Verdict |
|---|---|---|
| Delay1.reg | Disables UAC: `EnableLUA=0`, `ConsentPromptBehaviorAdmin=0`, `EnableVirtualization=0`, `ValidateAdminCodeSignatures=0` | **DANGEROUS** — any process can elevate without prompting. Also disables installer detection and code signature validation. |
| Delay2.reg | Power profile event GUIDs | Unclear effect, deep power profile modification |
| Delay3.reg | `CoalescingTimerInterval=0` for Power and Memory Management | Disables timer coalescing — increases wake-ups, may hurt battery, marginal latency gain |
| Delay4.reg | `Peernet\Disabled=0` | Enables P2P networking (opposite of what you'd want for privacy) |
| Delay5.reg | `WasLUADisabled=1` | UAC status flag — pairs with Delay1 |
| Delay6.reg | Legal notice caption/text: "Please login to let the final Maintenance Script do its work." | **Deceptive** — adds a fake system message on login |
| Delay7.reg | `DelayedDesktopSwitchTimeout=0` | Speeds desktop switch on login, minimal effect |
| Delay8.reg | `UserDuckingPreference=3` | **Legit** — disables Windows audio ducking during voice chat. Same as MaxxTopia's `audio.comms-ducking.disable`. |
| Delay9.reg | Hides Hibernate and Sleep options from Start menu | Removes power options — annoying, not performance |
| Delay10.reg | `NoAutoUpdate=1` — disables Windows Update | **Security risk** — no security patches |
| Delay11.reg | Explorer: show hidden files, show file extensions, disable search files | QoL changes, not performance |
| Delay12.reg | Folder type = NotSpecified | Explorer default folder view |
| Delay13.reg | `ContentEvaluation=0` | AppHost content evaluation off |
| Delay14.reg | `TimeStampInterval=1` | Reliability monitor timestamp |
| Delay15.reg | WPF/Avalon graphics: ClearType, multisample, HW acceleration | Desktop app rendering, not game performance |
| Delay16.reg | GPU driver: `vrrCursorMarginUs=1`, `TransitionLatency=1`, etc. | VRR tuning — marginal, driver-specific |
| Delay17.reg | NVIDIA `nvlddmkm` pipe optimization | Driver-level, may or may not exist as a real key |
| Delay18.reg | `VxD\BIOS`: `CPUPriority=1`, `FastDRAM=1`, `PCIConcur=1`, `AGPConcur=1` | **FAKE** — `VxD\BIOS` is a Windows 9x registry path that does nothing on Windows 10/11 |
| Delay19.reg | `Games\GameFluidity=1`, `FpsStatusGames=0x16`, `FpsAll=1` | **Likely placebo** — no documented Windows behavior for these keys |
| Delay20.reg | NTFS: `NtfsMftZoneReservation=1`, `NTFSDisable8dot3NameCreation=1`, `NTFSDisableLastAccessUpdate=1`, `ContigFileAllocSize=100` | Real NTFS tweaks — marginal disk performance, last-access is already off by default on Win11 |
| Delay21.reg | Intel GMM `DedicatedSegmentSize=1` | Intel iGPU memory — not applicable to discrete GPU |
| Delay22.reg | `VsyncIdleTimeout=0` under GraphicsDrivers\Scheduler | HAGS-related — marginal |
| Delay23.reg | MMCSS Games/Audio task affinity=0 | Resets CPU affinity for MMCSS game/audio tasks |

### ReduceInputDelay (9 .reg files)

| File | What it changes | Verdict |
|---|---|---|
| delay.reg | Power throttling off, MMCSS (`NetworkThrottlingIndex=0xa`, `SystemResponsiveness=0`, GPU Priority=8, Priority=6), GameDVR off, FSE mode, kill timeouts (HungAppTimeout=1000, WaitToKillServiceTimeout=2000), auto-maintenance off | Mix of real and folklore. GPU Priority=8 is not a real DXGK knob (per MaxxTopia's audit). NetworkThrottlingIndex and SystemResponsiveness only affect MMCSS-registered threads. Kill timeouts are real but aggressive. |
| delayy.reg | `Win32PrioritySeparation=0xfff55555` | **INVALID VALUE** — this is not a valid Win32PrioritySeparation setting. Could cause undefined scheduler behavior. |
| 2_Ping_Reduction_Strong.reg | `NetworkThrottlingIndex=0xffffffff`, `SystemResponsiveness=0` | Disables network throttling entirely. Credited to youtube.com/adamx17. Marginal — only affects MMCSS threads. |
| Controller_Tweaks_2.0.reg | `Win32PrioritySeparation=0x28` (40 decimal) | Higher than stock (38). Credited to Hexisy/Adamx. |
| ReduceInputDelay.reg | `Win32PrioritySeparation=0x28`, `FeatureSettings=1` (Meltdown/Spectre mitigations) | Priority separation + disables Spectre mitigations. Security reduction. |
| FPS.reg | `DisplayPostProcessing` MMCSS task: GPU Priority=0x12, Priority=8, LatencySensitive=True | Display post-processing priority — marginal, may not exist as a real task |
| fcshotgun.reg | TCP provider priorities: Local=4, Hosts=5, DNS=6, NetBT=7 | DNS resolution priority ordering — minimal effect on game ping |
| OverallShotGun.v1 (1).reg | Identical to fcshotgun.reg | Duplicate |
| shakey_best_input.reg | `MSMQ\Parameters\TCPNoDelay=1` | **Wrong path** — TCP NoDelay belongs under `Tcpip\Parameters\Interfaces\<NIC>`, not MSMQ. MSMQ is Microsoft Message Queuing, unrelated to game network traffic. |

### Aphrodite (3 .bat files)

| File | Size | Verdict |
|---|---|---|
| Aphrodite_Zero_Delay.bat | 1.7MB | **Obfuscated** — file is mostly encoded/garbage characters. Cannot audit what it does by reading. Creates a system restore point before running (per the Aim Assist variant's code). Targets Windows 10 only (checks `ver \| find "10."`). |
| Aphrodite_Aim_Assist_Enhancing.bat | 59KB | Readable batch. Creates restore point, sets ANSI console, then modifies system state. Name suggests aim assist modification — **anti-cheat risk** if it touches game memory or input hooks. |
| Aphrodite_Shotgun_Registration.bat | 13KB | Readable batch. Same structure as Aim Assist variant. Likely modifies registry for "shotgun registration" — claim is that it improves hit registration, which is server-side and not affected by client registry changes. |

### BloomReducer (1 .exe)

| File | Verdict |
|---|---|
| InternetBooster_4.11.4.0.exe | **Binary — cannot audit without running.** Claims to boost internet speed. Likely modifies network adapter settings or TCP stack. 1.2MB. |

## What actually works (from these packs)

Of all 36 files, only two changes have a documented, measured effect:

1. **Peterbot Delay8.reg** — `UserDuckingPreference=3` disables Windows audio ducking during voice chat. This is the same tweak as MaxxTopia's `audio.comms-ducking.disable`, independently confirmed as a real competitive-audio win.
2. **ReduceInputDelay delay.reg** — `GameDVR_Enabled=0` disables Windows Game DVR background recording. Real, modest stutter reduction. (Already applied on the target machine.)

Everything else is either:
- Security-reducing (UAC off, Windows Update off, Spectre mitigations off)
- Placebo (VxD BIOS keys, GameFluidity, GPU Priority=8, MSMQ TCPNoDelay)
- Invalid values (`Win32PrioritySeparation=0xfff55555`)
- Deceptive (fake legal notice on login)
- Obfuscated and unauditable (Aphrodite Zero Delay)
- Binary and unauditable (InternetBooster.exe)
- Real but marginal (NTFS tweaks, timer coalescing, MMCSS priorities)

## Sources

- Aphrodite packs: distributed via YouTube tutorials, credited to "Aphrodite Services"
- Peterbot: distributed as `PETERBOT_TWEAKS.zip`
- ReduceInputDelay: credited to Trimors, Hexisy, and youtube.com/AdamxYT
- BloomReducer: `InternetBooster_4.11.4.0.exe`, source unknown

## License

These files are preserved for research. No license is granted for the pack contents
themselves — they belong to their respective creators. This repository's documentation
(README, analysis) is MIT licensed.
