#Requires AutoHotkey v2.0
#SingleInstance Force
InstallKeybdHook()

; =====================================================================
;  Discovery Month Overlay v2  -  Vonnie in the Verse
;  (RSI Discovery Month event, 4.10.2. Window keeps the name "IASI Overlay"
;  so existing OBS Window Capture sources still find it.)
;  Free fan tool. Not affiliated with Cloud Imperium Games.
;  Starting values are from 4.10.2 PTU testing: check them on live.
;  Always-on-top, click-through readout for the 4.10.2 IASI event.
;  Tracks up to 6 mission types across the three event lanes and
;  the main track. Hotkeys work while Star Citizen has focus.
;
;  F9  = log a run for the active mission     F8 = undo a run
;  F6  = switch to the next mission
;  F10 = start/pause timer (hold 1 second to reset to 0:00:00)
;  F7  = move mode (drag it, press F7 again to lock)
;
;  Double-click the tray icon (or right-click > Edit missions & values)
;  to add missions, tick the active one and change prices. Changes
;  apply straight away and the timer keeps running.
; =====================================================================

; ---------- HOTKEYS (change these if they clash with your bindings) --
HK_LOG   := "F9"
HK_UNDO  := "F8"
HK_NEXT  := "F6"
HK_TIMER := "F10"
HK_MOVE  := "F7"
OPACITY  := 235      ; 0-255, lower = more see-through

; ---------- LOOK -----------------------------------------------------
BUILD := "DISCOVERY 4.10.2"   ; shown top-right of the panel
C_BG := "0E141B", C_BOX := "16202A", C_LINE := "2A3846", C_FG := "EEF3F7", C_MUTED := "93A3B4"
C_ACCENT := "FF8A3D", C_CYAN := "5CC8E8", C_RED := "FF6B6B", C_HIT := "15343F", C_DIM := "5A6878"

; Fonts: drop ChakraPetch-Bold.ttf, IBMPlexMono-Regular.ttf and IBMPlexMono-Bold.ttf
; (free from fonts.google.com) next to this script, or install them.
; Without them the overlay falls back to Bahnschrift and Consolas.
F_DISP := FontReady("Chakra Petch", ["ChakraPetch-Bold.ttf"]) ? "Chakra Petch" : "Bahnschrift SemiBold"
F_MONO := FontReady("IBM Plex Mono", ["IBMPlexMono-Regular.ttf", "IBMPlexMono-Bold.ttf"]) ? "IBM Plex Mono" : "Consolas"
F_BODY := "Segoe UI"

; ---------- STARTING MISSIONS (only used the first time) -------------
;  name, lane (1 Collection, 2 Transport, 3 Defence), points, payout,
;  raw handed in SCU, raw kept to refine SCU, RMC SCU, weapons
DEFAULTS := [
    ["Salvage M (quick)",      1, 255, 42000, 39, 8,  0, 0],
    ["Salvage M (full UCM)",   1, 255, 42000, 39, 80, 0, 0],
    ["Salvage M (full strip)", 1, 255, 42000, 39, 96, 8, 4],
    ["Salvage S",              1, 183, 30000, 1,  2,  0, 0],
    ["Transport",              2, 0,   0,     0,  0,  0, 0],
    ["Defence",                3, 0,   0,     0,  0,  0, 0]
]

; ---------- REWARDS (from the official Discovery Month reward screen) ----
LANE_REWARDS := [
    ["Ship + S2 Grade B Radar",      "Mantis HND & SPD",     "S3 Grade B Radar",      "Weapon"],
    ["Ship + S2 Grade B Cooler",     "Zeus Mk II HND & SPD", "S3 Grade B Cooler",     "Weapon"],
    ["Ship + S2 Grade B Powerplant", "Meteor HND & SPD",     "S3 Grade B Powerplant", "Weapon"]
]

; ---------- SETUP ----------------------------------------------------
INI    := A_ScriptDir "\IASI_Overlay_v2.ini"
LANES  := ["Collection", "Transport", "Defence"]
MAXP   := 6
FIELDS := ["pts", "pay", "hand", "keep", "rmc", "guns"]
CFG    := Map("YIELD", 0.308, "CMAT", 12000, "RMC", 9000, "GUN", 8199, "CAP", 10000, "MAIN", 30000)
CFGKEYS := ["YIELD", "CMAT", "RMC", "GUN", "CAP", "MAIN"]
CFGLABELS := Map("YIELD", "CMAT yield (0.308 = 30.8%)", "CMAT", "CMAT price (aUEC per SCU)"
    , "RMC", "RMC price (aUEC per SCU)", "GUN", "Weapon price (aUEC each)"
    , "CAP", "Lane cap (points)", "MAIN", "Main track total (points)")

PROF := []
loop MAXP {
    d := DEFAULTS[A_Index], sec := "mission" A_Index
    p := Map()
    p["name"] := IniRead(INI, sec, "name", d[1])
    p["lane"] := Min(3, Max(1, Integer(ReadNum(sec, "lane", d[2]))))
    for i, f in FIELDS
        p[f] := ReadNum(sec, f, d[i + 2])
    p["runs"] := Integer(ReadNum(sec, "runs", 0))
    PROF.Push(p)
}
for k in CFGKEYS
    CFG[k] := ReadNum("values", k, CFG[k])
startPts := [ReadNum("state", "start1", 0), ReadNum("state", "start2", 0), ReadNum("state", "start3", 0)]
active := Integer(ReadNum("state", "active", 1))
if (active < 1 || active > MAXP || PROF[active]["name"] = "")
    active := 1
tAcc := ReadNum("state", "timerAcc", 0)
posX := ReadNum("window", "x", 20)
posY := ReadNum("window", "y", 20)
tStart := 0, editMode := false, shown := true, sg := 0
totRuns := 0, totNet := 0

; ---------- BUILD THE READOUT ----------------------------------------
W := 340, H := 404
g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20", "IASI Overlay")
g.BackColor := C_BG

Box(x, y, w, h, col) => g.Add("Text", "x" x " y" y " w" w " h" h " Background" col)
Txt(opt, font, sz, col, label := "", bg := "") {
    g.SetFont("s" sz " c" col " norm", font)
    return g.Add("Text", opt (bg ? " Background" bg : ""), label)
}
TxtB(opt, font, sz, col, label := "", bg := "") {
    g.SetFont("s" sz " c" col " bold", font)
    return g.Add("Text", opt (bg ? " Background" bg : ""), label)
}

; orange frame
Box(0, 0, W, 1, C_ACCENT), Box(0, H - 1, W, 1, C_ACCENT)
Box(0, 0, 1, H, C_ACCENT), Box(W - 1, 0, 1, H, C_ACCENT)

; header
tTitle := TxtB("x14 y11 w236", F_DISP, 12, C_FG)
Txt("x250 y14 w76 Right", F_MONO, 7, C_MUTED, BUILD)

; time strip
Box(14, 38, 312, 40, C_BOX)
tClock := Txt("x22 y51 w60", F_MONO, 9, C_MUTED, "--:--", C_BOX)
tTimer := TxtB("x86 y42 w168 Center", F_DISP, 19, C_FG, "0:00:00", C_BOX)
tState := Txt("x258 y52 w62 Right", F_MONO, 7, C_MUTED, "READY", C_BOX)

; runs + lane points
tRuns := TxtB("x14 y82 w84", F_DISP, 28, C_ACCENT, "0")
tOf   := Txt("x96 y98 w110", F_DISP, 11, C_MUTED, "/ ? runs")
tLaneLbl := Txt("x196 y88 w130 Right", F_MONO, 7, C_MUTED, "")
tLanePts := TxtB("x166 y102 w160 Right", F_MONO, 10, C_FG, "")

; lane bar with tier ticks above it
progLane := g.Add("Progress", "x14 y132 w312 h12 -Theme c" C_ACCENT " Background" C_BOX " Range0-1000", 0)
TICKPCT := [0.2, 0.4, 0.65, 1.0]
ticks := []
for pc in TICKPCT
    ticks.Push(Box(14 + Round(312 * pc) - 1 - (pc = 1.0 ? 1 : 0), 127, 2, 4, C_DIM))

; tier chips
chips := []
loop 4
    chips.Push(Txt("x" (14 + (A_Index - 1) * 80) " y152 w72 h30 Center", F_MONO, 7, C_MUTED, "", C_BOX))

; main track
Txt("x14 y192 w140", F_MONO, 7, C_MUTED, "MAIN TRACK")
tMainPts := TxtB("x166 y190 w160 Right", F_MONO, 8, C_FG, "")
progMain := g.Add("Progress", "x14 y207 w312 h8 -Theme c" C_CYAN " Background" C_BOX " Range0-1000", 0)
tMainTiers := Txt("x14 y220 w312", F_MONO, 7, C_MUTED, "")
tLanes := Txt("x14 y236 w312", F_MONO, 7, C_MUTED, "")

; stat rows (label left, value right, hairline under)
Pair(label, x, y) {
    Txt("x" x " y" y " w70", F_BODY, 9, C_MUTED, label)
    v := TxtB("x" (x + 64) " y" y " w84 Right", F_MONO, 9, C_FG, "0")
    Box(x, y + 20, 148, 1, C_LINE)
    return v
}
vPay  := Pair("Payouts", 14, 258)
vCmat := Pair("CMAT",    178, 258)
vRmc  := Pair("RMC",     14, 284)
vGuns := Pair("Weapons", 178, 284)
vRph  := Pair("Runs/hr", 14, 310)
vAph  := Pair("aUEC/hr", 178, 310)

; net box
Box(14, 340, 312, 38, C_BOX)
Txt("x24 y353 w100", F_MONO, 7, C_MUTED, "EARNED SO FAR", C_BOX)
vNet := TxtB("x130 y345 w186 Right", F_DISP, 15, C_FG, "0", C_BOX)

Txt("x14 y384 w312", F_MONO, 6, C_DIM, HK_LOG " run  " HK_UNDO " undo  " HK_NEXT " mission  " HK_TIMER " timer  " HK_MOVE " move")

g.Show("x" posX " y" posY " w" W " h" H " NoActivate")
WinSetTransparent(OPACITY, g)

; ---------- HOTKEYS, TRAY, TIMERS ------------------------------------
Hotkey("$" HK_LOG,   (*) => AddRun(1))
Hotkey("$" HK_UNDO,  (*) => AddRun(-1))
Hotkey("$" HK_NEXT,  (*) => NextMission())
Hotkey("$" HK_TIMER, TimerKey)
Hotkey("$" HK_MOVE,  (*) => ToggleMove())

A_TrayMenu.Insert("1&", "Edit missions && values...", (*) => OpenSettings())
A_TrayMenu.Insert("2&", "Next mission (" HK_NEXT ")", (*) => NextMission())
A_TrayMenu.Insert("3&", "Show / hide overlay", (*) => ToggleShow())
A_TrayMenu.Insert("4&", "Move overlay (" HK_MOVE ")", (*) => ToggleMove())
A_TrayMenu.Insert("5&", "Reset all runs", (*) => ResetRuns())
A_TrayMenu.Insert("6&", "Reset timer", (*) => ResetTimer())
A_TrayMenu.Insert("7&")
A_TrayMenu.Default := "Edit missions && values..."
A_IconTip := "Discovery Month Overlay"

OnMessage(0x201, OnLeftDown)
OnExit(SaveAll)
SetTimer(Tick, 1000)
Update()

; ---------- LOGIC ----------------------------------------------------
FontReady(name, files) {
    ok := false
    for f in files {
        path := A_ScriptDir "\" f
        if FileExist(path) {
            DllCall("gdi32\AddFontResourceEx", "Str", path, "UInt", 0x10, "Ptr", 0)
            ok := true
        }
    }
    if ok
        return true
    for root in ["HKLM", "HKCU"] {
        loop reg root "\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            if InStr(A_LoopRegName, name)
                return true
    }
    return false
}

ReadNum(sec, key, def) {
    s := IniRead(INI, sec, key, "")
    return IsNumber(s) ? Number(s) : def
}

LanePts(l) {
    total := startPts[l]
    for p in PROF
        if (p["lane"] = l && p["name"] != "")
            total += p["runs"] * p["pts"]
    return Min(total, CFG["CAP"])
}

MainPts() => LanePts(1) + LanePts(2) + LanePts(3)

; Earned per run: what lands in your wallet. The cargo you hand in is not
; subtracted, because it was salvaged for free and the payout is what you get for it.
NetOf(p) => p["pay"] + p["keep"] * CFG["YIELD"] * CFG["CMAT"]
          + p["rmc"] * CFG["RMC"] + p["guns"] * CFG["GUN"]

Elapsed() => tAcc + (tStart ? A_TickCount - tStart : 0)

TierLine(have, total, tiers, ppr) {
    line := ""
    for t in tiers {
        need := total * t[1]
        if (have >= need)
            line .= t[2] " ✓    "
        else if (ppr > 0)
            line .= t[2] " " Ceil((need - have) / ppr) "    "
        else
            line .= t[2] " " Short(need - have) "    "
    }
    return RTrim(line)
}

Update() {
    global totRuns, totNet
    ap := PROF[active], l := ap["lane"], cap := CFG["CAP"]
    if editMode
        tTitle.Value := "DRAG · " HK_MOVE " TO LOCK"
    else
        tTitle.Value := StrUpper(ap["name"]) (ap["pts"] > 0 ? "" : " · SET POINTS")

    lp := LanePts(l)
    left := ap["pts"] > 0 ? Ceil(Max(0, cap - lp) / ap["pts"]) : -1
    tRuns.Value := ap["runs"]
    tOf.Value := left >= 0 ? "/ " (ap["runs"] + left) " runs" : "/ ? runs"
    tLaneLbl.Value := StrUpper(LANES[l]) " POINTS"
    tLanePts.Value := Fmt(lp) " / " Fmt(cap)
    progLane.Value := Round(lp / cap * 1000)
    names := ["T1", "T2", "T3", "CAP"]
    for idx, pc in TICKPCT {
        need := cap * pc, hit := lp >= need
        ticks[idx].Opt("+Background" (hit ? C_CYAN : C_DIM)), ticks[idx].Redraw()
        chips[idx].Opt("+Background" (hit ? C_HIT : C_BOX))
        chips[idx].SetFont("c" (hit ? C_CYAN : C_MUTED))
        chips[idx].Value := names[idx] "`n" (hit ? "done" : ap["pts"] > 0 ? Ceil((need - lp) / ap["pts"]) " to go" : Short(need - lp) " pts")
        chips[idx].Redraw()
    }

    mp := MainPts(), mt := CFG["MAIN"]
    tMainPts.Value := Fmt(mp) " / " Fmt(mt)
    progMain.Value := Round(Min(mp, mt) / mt * 1000)
    nxt := "LANE DONE"
    for idx, pc in TICKPCT
        if (lp < cap * pc) {
            nxt := "NEXT " names[idx] " · " LANE_REWARDS[l][idx]
            break
        }
    tMainTiers.Value := nxt
    tLanes.Value := "COL " Fmt(LanePts(1)) "   TRN " Fmt(LanePts(2)) "   DEF " Fmt(LanePts(3))

    pay := 0, cm := 0, rm := 0, gn := 0, nt := 0, n := 0
    for p in PROF {
        if (p["name"] = "")
            continue
        r := p["runs"]
        pay += r * p["pay"]
        cm  += r * p["keep"] * CFG["YIELD"]
        rm  += r * p["rmc"]
        gn  += r * p["guns"]
        nt  += r * NetOf(p)
        n   += r
    }
    totRuns := n, totNet := nt
    if sg {   ; keep the missions window in step with hotkey runs
        loop MAXP
            try sg["Runs" A_Index].Value := PROF[A_Index]["runs"]
    }
    vPay.Value  := Short(pay)
    vCmat.Value := Fmt(cm) " SCU"
    vRmc.Value  := Fmt(rm) " SCU"
    vGuns.Value := Fmt(gn)
    vNet.Value  := (nt > 0 ? "+" : "") Short(nt)
    vNet.SetFont("c" (nt > 0 ? C_CYAN : nt < 0 ? C_RED : C_FG))
    Tick()
    SaveAll()
}

Tick(*) {
    tClock.Value := FormatTime(, "HH:mm")
    ms := Elapsed()
    tTimer.Value := HMS(ms)
    if tStart {
        tState.Value := "● LIVE"
        tState.SetFont("c" C_ACCENT)
        tTimer.SetFont("c" C_FG)
    } else {
        tState.Value := ms ? "PAUSED" : "READY"
        tState.SetFont("c" C_MUTED)
        tTimer.SetFont("c" C_MUTED)
    }
    hrs := ms / 3600000
    if (hrs > 0.01 && totRuns > 0) {
        vRph.Value := Format("{:.1f}", totRuns / hrs)
        vAph.Value := Short(totNet / hrs)
    } else {
        vRph.Value := "–"
        vAph.Value := "–"
    }
}

AddRun(n) {
    PROF[active]["runs"] := Max(0, PROF[active]["runs"] + n)
    Update()
}

NextMission() {
    global active
    loop MAXP {
        active := Mod(active, MAXP) + 1
        if (PROF[active]["name"] != "")
            break
    }
    Update()
}

TimerKey(*) {
    ; tap = start/pause, hold for 1 second = reset
    if !KeyWait(HK_TIMER, "T1") {
        ResetTimer()
        tState.Value := "RESET"
        tState.SetFont("c" C_CYAN)
        KeyWait(HK_TIMER)
    } else {
        ToggleTimer()
    }
}

ToggleTimer() {
    global tAcc, tStart
    if tStart {
        tAcc += A_TickCount - tStart
        tStart := 0
    } else {
        tStart := A_TickCount
    }
    Tick()
    SaveAll()
}

ResetTimer() {
    global tAcc, tStart
    tAcc := 0, tStart := 0
    Tick()
    SaveAll()
}

ResetRuns() {
    if MsgBox("Reset the run count for every mission to 0?", "IASI Overlay", "YesNo Icon?") = "Yes" {
        for p in PROF
            p["runs"] := 0
        Update()
    }
}

ToggleMove() {
    global editMode
    editMode := !editMode
    if editMode {
        g.Opt("-E0x20")
        WinSetTransparent(255, g)
    } else {
        g.Opt("+E0x20")
        WinSetTransparent(OPACITY, g)
    }
    Update()
}

ToggleShow() {
    global shown
    shown := !shown
    if shown
        g.Show("NoActivate")
    else
        g.Hide()
}

OnLeftDown(wParam, lParam, msg, hwnd) {
    if editMode
        PostMessage(0xA1, 2, 0, , "ahk_id " g.Hwnd)   ; drag the window
}

SaveAll(*) {
    loop MAXP {
        p := PROF[A_Index], sec := "mission" A_Index
        IniWrite(p["name"], INI, sec, "name")
        IniWrite(p["lane"], INI, sec, "lane")
        for f in FIELDS
            IniWrite(p[f], INI, sec, f)
        IniWrite(p["runs"], INI, sec, "runs")
    }
    for k in CFGKEYS
        IniWrite(CFG[k], INI, "values", k)
    loop 3
        IniWrite(startPts[A_Index], INI, "state", "start" A_Index)
    IniWrite(active, INI, "state", "active")
    IniWrite(Elapsed(), INI, "state", "timerAcc")
    try {
        WinGetPos(&x, &y, , , g)
        IniWrite(x, INI, "window", "x")
        IniWrite(y, INI, "window", "y")
    }
}

; ---------- MISSIONS & VALUES WINDOW ---------------------------------
OpenSettings() {
    global sg
    if sg {
        sg.Show()
        return
    }
    sg := Gui("+AlwaysOnTop +ToolWindow", "IASI Overlay - Missions & Values")
    sg.SetFont("s9", "Segoe UI")
    cols := [["Active", 50], ["Mission name", 170], ["Lane", 95], ["Points", 60], ["Payout", 75]
        , ["Hand-in SCU", 75], ["Kept SCU", 65], ["RMC SCU", 60], ["Weapons", 60], ["Runs", 50]]
    x := 10
    for c in cols {
        sg.Add("Text", "x" x " y10 w" c[2], c[1])
        x += c[2] + 6
    }
    y := 32
    loop MAXP {
        i := A_Index, p := PROF[i]
        sg.Add("Radio", "x27 y" (y + 4) " w20" (i = 1 ? " Group vAct" : "") (i = active ? " Checked" : ""))
        x := 66
        sg.Add("Edit", "x" x " y" y " w170 vName" i, p["name"])
        x += 176
        sg.Add("DropDownList", "x" x " y" y " w95 AltSubmit vLane" i " Choose" p["lane"], LANES)
        x += 101
        for j, f in FIELDS {
            w := cols[j + 3][2]
            sg.Add("Edit", "x" x " y" y " w" w " Right v" f i, p[f])
            x += w + 6
        }
        sg.Add("Edit", "x" x " y" y " w50 Right vRuns" i, p["runs"])
        y += 28
    }
    sg.Add("Text", "x10 y" (y + 2) " w760 c808080", "Tick the mission you're running. Leave a name blank to hide that row. Lanes add up all their missions.")
    y += 30
    top := y
    sg.SetFont("s9 bold")
    sg.Add("Text", "x10 y" y " w300", "Shared prices and caps")
    sg.Add("Text", "x400 y" y " w300", "Lane points earned before tracking")
    sg.SetFont("s9 norm")
    y += 24
    for k in CFGKEYS {
        sg.Add("Text", "x10 y" (y + 3) " w200", CFGLABELS[k])
        sg.Add("Edit", "x215 y" y " w100 Right v" k, CFG[k])
        y += 26
    }
    y2 := top + 24
    loop 3 {
        sg.Add("Text", "x400 y" (y2 + 3) " w120", LANES[A_Index])
        sg.Add("Edit", "x525 y" y2 " w100 Right vStart" A_Index, startPts[A_Index])
        y2 += 26
    }
    y += 10
    sg.Add("Button", "x10 y" y " w150 Default", "Apply").OnEvent("Click", ApplySettings)
    sg.Add("Button", "x+18 w150", "Close").OnEvent("Click", (*) => CloseSettings())
    sg.Add("Text", "x+18 yp+5 w400 c808080", "Changes apply straight away. The timer keeps running.")
    sg.OnEvent("Close", (*) => CloseSettings())
    sg.OnEvent("Escape", (*) => CloseSettings())
    sg.Show()
}

ApplySettings(*) {
    global active
    vals := sg.Submit(false)
    bad := ""
    loop MAXP {
        i := A_Index, p := PROF[i]
        p["name"] := Trim(vals.%"Name" i%)
        p["lane"] := Min(3, Max(1, Integer(vals.%"Lane" i%)))
        for f in FIELDS {
            s := Trim(vals.%f i%)
            if (IsNumber(s) && Number(s) >= 0)
                p[f] := Number(s)
            else
                bad .= "`n- Row " i ": " f
        }
        s := Trim(vals.%"Runs" i%)
        if (IsInteger(s) && Integer(s) >= 0)
            p["runs"] := Integer(s)
        else
            bad .= "`n- Row " i ": runs"
    }
    for k in CFGKEYS {
        s := Trim(vals.%k%)
        if (IsNumber(s) && Number(s) > 0)
            CFG[k] := Number(s)
        else
            bad .= "`n- " CFGLABELS[k]
    }
    loop 3 {
        s := Trim(vals.%"Start" A_Index%)
        if (IsNumber(s) && Number(s) >= 0)
            startPts[A_Index] := Number(s)
        else
            bad .= "`n- Starting points: " LANES[A_Index]
    }
    if (vals.Act >= 1 && PROF[vals.Act]["name"] != "")
        active := vals.Act
    if (PROF[active]["name"] = "") {
        found := 0
        loop MAXP
            if (PROF[A_Index]["name"] != "") {
                found := A_Index
                break
            }
        if !found
            PROF[1]["name"] := "Mission 1", found := 1
        active := found
    }
    Update()
    if bad
        MsgBox("These need a number, so they were left as they were:" bad, "IASI Overlay", "Icon!")
}

CloseSettings() {
    global sg
    if sg {
        sg.Destroy()
        sg := 0
    }
}

; ---------- FORMATTING -----------------------------------------------
Fmt(n) {
    n := Round(n)
    s := n < 0 ? "-" : ""
    return s RegExReplace(String(Abs(n)), "\G\d+?(?=(\d{3})+$)", "$0,")
}

Short(n) {
    a := Abs(n), s := n < 0 ? "-" : ""
    if a >= 1000000
        return s Format("{:.2f}M", a / 1000000)
    if a >= 1000
        return s Round(a / 1000) "k"
    return s Round(a)
}

HMS(ms) {
    t := ms // 1000
    return (t // 3600) ":" Format("{:02}", Mod(t // 60, 60)) ":" Format("{:02}", Mod(t, 60))
}
