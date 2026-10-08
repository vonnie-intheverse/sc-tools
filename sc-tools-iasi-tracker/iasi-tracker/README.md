# IASI Event Tracker

Free run tracker for the Star Citizen 4.10.2 IASI event, by Vonnie in the Verse.

**Live:** https://vonnie-intheverse.github.io/sc-tools/iasi-tracker/

## What it does

- Tracks up to six mission types across the Collection, Transport and Defence lanes
- Lane bar and tier chips (T1 20%, T2 40%, T3 65%, cap at 10,000) with runs left to each tier
- Main-track bar out of 30,000 (M1 15%, M2 33%, M3 80%, M4 100%)
- Session timer, clock, runs per hour and aUEC per hour
- Earned so far: payout + kept SCU refined to CMAT + RMC + weapons, at your own prices
- Saves in your browser, so a refresh doesn't lose anything

## Two versions

| | Web tracker (`index.html`) | Desktop overlay (`IASI_Overlay.ahk`) |
|---|---|---|
| Runs in | Any browser | Windows, with AutoHotkey v2 |
| Logging runs | Click, or Space while the tab is focused | F9 / F8 hotkeys, even while in game |
| On stream | OBS Browser source with `?overlay` | Always-on-top, click-through panel |

### Web tracker keys
Space log a run · Backspace undo · M next mission · T start or pause timer

### OBS
Browser source: `https://vonnie-intheverse.github.io/sc-tools/iasi-tracker/?overlay`
Chroma-key the green, or add `&bg=transparent`. Right-click the source and choose **Interact** to log runs inside OBS.

### Desktop overlay
1. Install AutoHotkey v2 from autohotkey.com
2. Put `IASI_Overlay.ahk` in its own folder and double-click it
3. Run Star Citizen in Borderless
4. F9 run · F8 undo · F6 next mission · F10 timer (hold to reset) · F7 move
5. Double-click the tray icon to edit missions and prices

## Starting values

The defaults come from 4.10.2 PTU testing and may change at launch. Check them against your first live run.

| Mission | Points | Payout | Hand-in | Kept |
|---|---|---|---|---|
| Salvage M (quick) | 255 | 42,000 | 39 SCU | 8 SCU |
| Salvage M (full UCM) | 255 | 42,000 | 39 SCU | 80 SCU |
| Salvage M (full strip) | 255 | 42,000 | 39 SCU | 96 SCU + 8 RMC + 4 guns |
| Salvage S | 183 | 30,000 | 1 SCU | 2 SCU |

---

Free fan-made tool. Not affiliated with Cloud Imperium Games. Star Citizen®, Roberts Space Industries® and Cloud Imperium® are trademarks of Cloud Imperium Rights LLC.
