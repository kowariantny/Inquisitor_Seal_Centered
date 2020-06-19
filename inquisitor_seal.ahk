#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 1000 
#MaxThreadsPerHotkey 1
#HotkeyModifierTimeout -1
#KeyHistory 50
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 3
Menu, Tray, Icon , *, -1, 1

#Include Defaults.ahk
#Include CommonFunctions.ahk

shift := 0
hotkeys_inactive_fix := false


config_name := % StrSplit(A_ScriptName, ".")[1] . "." . _CONFIG_FILE_EXTENSION
If (!FileExist(config_name))
{
    MsgBox, %config_name% not found
    ExitApp
}

IniRead, game_window_id, % config_name, general, game_window_id, % _GAME_WINDOW_ID
if (!Common.Configured(game_window_id))
{
    MsgBox, Missing "game_window_id" in the config, i.e. game_window_id=ahk_exe Grim Dawn.exe in [general] section.
    ExitApp
}

IniRead, key_big_picture, % config_name, general, key_big_picture
if (!Common.Configured(key_big_picture))
{
    MsgBox, Missing "key_big_picture" in the config, i.e. key_big_picture=h in [general] section.
    ExitApp
}

IniRead, key_hotbar, % config_name, general, key_hotbar
if (!Common.Configured(key_hotbar))
{
    MsgBox, Missing "key_hotbar" in the config, i.e. key_hotbar=RButton in [general] section.
    ExitApp
}

IniRead, delay, % config_name, general, delay
if (!Common.Configured(delay))
{
    MsgBox, Missing "delay" in the config, i.e. delay=40 in [general] section.
    ExitApp
}

IniRead, vertical_pixel_shift, % config_name, general, vertical_pixel_shift, 0

Hotkey, %key_big_picture%, seal, On

SetTimer, MainLoop, % _AUTOMATIC_HOTKEY_SUSPENSION_LOOP_DELAY
MainLoop()
{
    global game_window_id
    global hotkeys_inactive_fix

    if (!WinActive(game_window_id))
    {
        if (!A_IsSuspended)
            Suspend, On
                    
        hotkeys_inactive_fix := false
    }    
    else
    {
        if (!hotkeys_inactive_fix)
        {
            Suspend, On
            Suspend, Off
            hotkeys_inactive_fix := true
        }
        
        Suspend, Off
    }
}

seal()
{
    global shift
    global vertical_pixel_shift
    global delay
    global key_hotbar

    WinGetActiveStats, Title, Width, Height, X, Y
    MouseMove, shift + Width/2, Height/2 - vertical_pixel_shift, 0
    shift := shift ^ 1
    Sleep, %delay%
    Send {%key_hotbar%}
}



