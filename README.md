# SC Tools

Free planning tools for Star Citizen, built by [Vonnie In The Verse](https://www.youtube.com/@Vonnie_InTheVerse).

Live at **https://vonnie-intheverse.github.io/sc-tools/**
SCA - **https://vonnie-intheverse.github.io/sc-tools/sca/**
Discovery Month Tracker - **https://vonnie-intheverse.github.io/sc-tools/iasi-tracker/**

This is an unofficial Star Citizen fan site, not affiliated with the Cloud Imperium
group of companies. All content on this site not authored by its host or users are
property of their respective owners. Official site: https://robertsspaceindustries.com

Everything here is free. No paywalls, no subscriptions, no donation links — per
CIG's fan content policy, and because that's the point.

## What's here

| Page | What it does |
|---|---|
| `index.html` | Hub — lists the tools |
| `exchange-matrix.html` | Wikelo tracker, channel branding, farm-rate/time layer |
| `sca/index.html` | Same tracker for Southern Cross Alliance, no channel branding |
| `iasi-tracker/index.html` | Discovery Month event tracker: lanes, main track, next reward, timer, aUEC/hr, OBS overlay mode (`?overlay`) |
| `iasi-tracker/IASI_Overlay.ahk` | Desktop version of the event tracker (AutoHotkey v2) with in-game hotkeys |
| `data/recipes.js` | **All Wikelo recipe data. Patch day: edit this file only.** |
| `data/prices.json` | Written by the UEX workflow (optional, see below) |

## Patch day

1. Open `data/recipes.js`.
2. Fix any quantities that changed against the live in-game contract.
3. Bump `VERIFIED` at the top — it renders in the footer of every page.
4. Commit. Pages redeploys in a minute or two.

Both trackers read the same file, so that's one edit, not three.

## Discovery Month Tracker

The event tracker keeps its own data, separate from the Wikelo files.

- **Starting missions and prices:** the `DEFAULTS` block near the top of the script in
  `iasi-tracker/index.html`, and the `DEFAULTS` block near the top of `IASI_Overlay.ahk`.
  Visitors' own edits save to their browser (or a local `.ini` for the desktop version),
  so changing the defaults only affects new users.
- **Rewards:** the `REWARDS` block in `index.html` and `LANE_REWARDS` in the `.ahk`.
  Replace "Unnamed" entries once CIG names the items.
- **Keep the folder name `iasi-tracker`.** Videos and posts already link to that address.
- Browsers may warn when downloading the `.ahk` because it's a script. That's expected.

## Farm rates

`exchange-matrix.html` has a `RATES` block near the top of its script — units per hour
per material. **The values shipped are placeholders.** Replace them with numbers
measured from recorded runs. Visitors can override any rate in the table; their edits
save to their own browser, not to this repo.

## UEX prices (optional)

`.github/workflows/uex-prices.yml` fetches commodity prices once a day and commits
`data/prices.json`. It is disabled until you add a repository secret named
`UEX_SECRET_KEY` (Settings → Secrets and variables → Actions).

Never put the key in a page. This repo is public; anything in a file here is published.

Check UEX's API terms for attribution requirements before shipping anything that
displays their data, and label market prices as indicative — asking prices, not guarantees.
