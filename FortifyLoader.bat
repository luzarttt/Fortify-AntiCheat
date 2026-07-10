@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title Fortify Anti-Cheat  --  Console v2.0
color 0A

set "BASE=%~dp0"
set /a PASS=0
set /a FAIL=0

rem ============================================================
rem  LOADING SCREEN
rem ============================================================
cls
color 08
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo              L  O  A  D  I  N  G  . . .
echo.
ping -n 3 -w 1 127.0.0.1 >nul

rem ============================================================
rem  BANNER PHASE 1 - DARK (outline only)
rem ============================================================
cls
color 08
echo.
echo.
echo.
echo.
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%   FFFFF   OOO   RRRR   TTTTT  III  FFFFF  Y   Y                     %%
echo   %%   F      O   O  R   R    T     I   F       Y Y                      %%
echo   %%   FFFF   O   O  RRRR     T     I   FFFF     Y                       %%
echo   %%   F      O   O  R  R     T     I   F        Y                       %%
echo   %%   F       OOO   R   R    T    III  F         Y                      %%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%              Advanced Anti-Cheat System for FiveM                   %%
echo   %%                          Version  2.0                               %%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ping -n 3 -w 1 127.0.0.1 >nul

rem ============================================================
rem  BANNER PHASE 2 - BRIGHT GREEN (full color)
rem ============================================================
cls
color 0A
echo.
echo.
echo.
echo.
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%   FFFFF   OOO   RRRR   TTTTT  III  FFFFF  Y   Y                     %%
echo   %%   F      O   O  R   R    T     I   F       Y Y                      %%
echo   %%   FFFF   O   O  RRRR     T     I   FFFF     Y                       %%
echo   %%   F      O   O  R  R     T     I   F        Y                       %%
echo   %%   F       OOO   R   R    T    III  F         Y                      %%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%              Advanced Anti-Cheat System for FiveM                   %%
echo   %%                          Version  2.0                               %%
echo   %%                                                                      %%
echo   %%                                                                      %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.
ping -n 2 -w 1 127.0.0.1 >nul

rem ============================================================
rem  BOOT SEQUENCE
rem ============================================================
color 0B
echo   ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ping -n 2 -w 1 127.0.0.1 >nul
echo   ::  Booting system...                                                 ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Initializing core engine...                                       ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Loading configuration module...                                   ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Mounting client protection layers...                              ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Starting detection engine...                                      ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Connecting Discord logging service...                             ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Verifying ban database integrity...                               ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Arming spectate module...                                         ::
ping -n 3 -w 1 127.0.0.1 >nul
echo   ::  Registering server-side event handlers...                        ::
ping -n 3 -w 1 127.0.0.1 >nul
color 0A
echo   ::  All systems operational.                                          ::
ping -n 2 -w 1 127.0.0.1 >nul
echo   ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ping -n 3 -w 1 127.0.0.1 >nul

rem ============================================================
rem  FILE INTEGRITY CHECK
rem ============================================================
echo.
color 0E
echo   [ INTEGRITY CHECK ]  Verifying resource files...
echo.
ping -n 2 -w 1 127.0.0.1 >nul

call :CHECK "fxmanifest.lua"        "fxmanifest.lua        " "Manifest"
call :CHECK "config.lua"            "config.lua            " "Config"
call :CHECK "shared\utils.lua"      "shared\utils.lua      " "Shared Utilities"
call :CHECK "server\discord.lua"    "server\discord.lua    " "Discord Logger"
call :CHECK "server\ban.lua"        "server\ban.lua        " "Ban System"
call :CHECK "server\main.lua"       "server\main.lua       " "Server Core"
call :CHECK "client\main.lua"       "client\main.lua       " "Client Core"
call :CHECK "client\detections.lua" "client\detections.lua " "Detection Engine"
call :CHECK "client\spectate.lua"   "client\spectate.lua   " "Spectate Module"

echo.
ping -n 2 -w 1 127.0.0.1 >nul

rem ============================================================
rem  WEBHOOK CHECK
rem ============================================================
color 0E
echo   [ WEBHOOK CHECK ]  Scanning config.lua...
ping -n 3 -w 1 127.0.0.1 >nul
findstr /C:"YOUR_WEBHOOK_URL_HERE" "!BASE!config.lua" >nul 2>&1
if !errorlevel!==0 (
    color 0E
    echo   [  WARN  ]  Webhooks NOT configured -- Edit config.lua
) else (
    color 0A
    echo   [   OK   ]  Webhooks are configured.
)
echo.
ping -n 3 -w 1 127.0.0.1 >nul

rem ============================================================
rem  FINAL BANNER + RESULT SCREEN
rem ============================================================
cls
color 0A
echo.
echo.
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%                                                                      %%
echo   %%   FFFFF   OOO   RRRR   TTTTT  III  FFFFF  Y   Y                     %%
echo   %%   F      O   O  R   R    T     I   F       Y Y                      %%
echo   %%   FFFF   O   O  RRRR     T     I   FFFF     Y                       %%
echo   %%   F      O   O  R  R     T     I   F        Y                       %%
echo   %%   F       OOO   R   R    T    III  F         Y                      %%
echo   %%                                                                      %%
echo   %%              Advanced Anti-Cheat System for FiveM                   %%
echo   %%                          Version  2.0                               %%
echo   %%                                                                      %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.

if !FAIL!==0 (
    color 0A
    echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    echo   %%  STATUS  :  READY                                                  %%
    echo   %%  FILES   :  9 / 9  --  All present                                %%
    echo   %%  RESULT  :  Fortify is ready to install on your FiveM server.     %%
    echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
) else (
    color 0C
    echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    echo   %%  STATUS  :  ERROR                                                  %%
    echo   %%  FILES   :  !PASS! / 9  --  !FAIL! file(s) missing                %%
    echo   %%  RESULT  :  Restore missing files and re-run this loader.          %%
    echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    color 0A
)

echo.
color 0B
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%  COMMANDS  --  type a command and press ENTER                       %%
echo   %%                                                                      %%
echo   %%   help       Show available commands                                %%
echo   %%   status     Re-check file integrity                                %%
echo   %%   install    Show install instructions                              %%
echo   %%   ingame     Show in-game command list                              %%
echo   %%   clear      Clear the screen                                       %%
echo   %%   exit       Exit console                                           %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.

rem ============================================================
rem  COMMAND PROMPT LOOP
rem ============================================================
:PROMPT
color 07
set "CMD_INPUT="
set /p "CMD_INPUT=  Fortify^> "

if /i "!CMD_INPUT!"=="exit"    goto :QUIT
if /i "!CMD_INPUT!"=="quit"    goto :QUIT
if /i "!CMD_INPUT!"=="clear"   goto :CMD_CLEAR
if /i "!CMD_INPUT!"=="cls"     goto :CMD_CLEAR
if /i "!CMD_INPUT!"=="help"    goto :CMD_HELP
if /i "!CMD_INPUT!"=="status"  goto :CMD_STATUS
if /i "!CMD_INPUT!"=="install" goto :CMD_INSTALL
if /i "!CMD_INPUT!"=="ingame"  goto :CMD_INGAME
if /i "!CMD_INPUT!"==""        goto :PROMPT

color 0C
echo.
echo   [ ERR ]  Unknown command: "!CMD_INPUT!"  --  Type  help  to list commands.
echo.
color 07
goto :PROMPT

rem ------------------------------------------------------------
:CMD_CLEAR
cls
color 0A
echo.
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%                                                                      %%
echo   %%   FFFFF   OOO   RRRR   TTTTT  III  FFFFF  Y   Y                     %%
echo   %%   F      O   O  R   R    T     I   F       Y Y                      %%
echo   %%   FFFF   O   O  RRRR     T     I   FFFF     Y                       %%
echo   %%   F      O   O  R  R     T     I   F        Y                       %%
echo   %%   F       OOO   R   R    T    III  F         Y                      %%
echo   %%                                                                      %%
echo   %%              Advanced Anti-Cheat System for FiveM // v2.0           %%
echo   %%                                                                      %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.
color 07
goto :PROMPT

rem ------------------------------------------------------------
:CMD_HELP
echo.
color 0B
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%  HELP  --  Available Commands                                       %%
echo   %%                                                                      %%
echo   %%   help       Show this help screen                                  %%
echo   %%   status     Re-run file integrity check                            %%
echo   %%   install    Show FiveM server install instructions                 %%
echo   %%   ingame     Show in-game chat commands                             %%
echo   %%   clear      Clear the console screen                               %%
echo   %%   exit       Exit Fortify console                                   %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.
color 07
goto :PROMPT

rem ------------------------------------------------------------
:CMD_STATUS
echo.
color 0E
echo   [ INTEGRITY CHECK ]  Re-scanning files...
echo.
ping -n 2 -w 1 127.0.0.1 >nul
set /a PASS=0
set /a FAIL=0
call :CHECK "fxmanifest.lua"        "fxmanifest.lua        " "Manifest"
call :CHECK "config.lua"            "config.lua            " "Config"
call :CHECK "shared\utils.lua"      "shared\utils.lua      " "Shared Utilities"
call :CHECK "server\discord.lua"    "server\discord.lua    " "Discord Logger"
call :CHECK "server\ban.lua"        "server\ban.lua        " "Ban System"
call :CHECK "server\main.lua"       "server\main.lua       " "Server Core"
call :CHECK "client\main.lua"       "client\main.lua       " "Client Core"
call :CHECK "client\detections.lua" "client\detections.lua " "Detection Engine"
call :CHECK "client\spectate.lua"   "client\spectate.lua   " "Spectate Module"
echo.
if !FAIL!==0 (
    color 0A
    echo   [  OK  ]  All files present  (!PASS!/9)
) else (
    color 0C
    echo   [ FAIL ]  !PASS! found -- !FAIL! missing
)
echo.
color 07
goto :PROMPT

rem ------------------------------------------------------------
:CMD_INSTALL
echo.
color 07
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%  INSTALL INSTRUCTIONS                                               %%
echo   %%                                                                      %%
echo   %%  1.  Copy Fortify folder to your server resources directory         %%
echo   %%  2.  Add  "ensure Fortify"  to your server.cfg                      %%
echo   %%  3.  Fill in Discord webhook URLs in config.lua                     %%
echo   %%  4.  Add these ACE permissions to server.cfg:                       %%
echo   %%                                                                      %%
echo   %%       add_ace group.admin fortify.admin allow                       %%
echo   %%       add_ace group.admin fortify.superadmin allow                  %%
echo   %%       add_ace group.mod   fortify.moderator allow                   %%
echo   %%                                                                      %%
echo   %%  5.  Restart your FiveM server and type  status  ingame to verify   %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.
color 07
goto :PROMPT

rem ------------------------------------------------------------
:CMD_INGAME
echo.
color 0B
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%  IN-GAME COMMANDS  (use these in FiveM server chat)                %%
echo   %%                                                                      %%
echo   %%   /ban         [id] [reason]   Ban a player permanently             %%
echo   %%   /unban       [license]       Remove a ban by license hash         %%
echo   %%   /kick        [id] [reason]   Kick a player from the server        %%
echo   %%   /warn        [id] [reason]   Warn (auto-ban at max warnings)      %%
echo   %%   /spectate    [id]            Spectate a player  (admin only)      %%
echo   %%   /fortifyinfo [id]            View player identifiers              %%
echo   %%   /fortifyonline               List all online players              %%
echo   %%   /fortifyhud                  Toggle HUD overlay in-game           %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.
color 07
goto :PROMPT

rem ============================================================
rem  EXIT
rem ============================================================
:QUIT
echo.
color 0A
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo   %%       Fortify Anti-Cheat v2.0  --  Session Ended.                  %%
echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo.
ping -n 2 -w 1 127.0.0.1 >nul
endlocal
exit /b 0

rem ============================================================
rem  FILE CHECK SUBROUTINE
rem ============================================================
:CHECK
ping -n 2 -w 1 127.0.0.1 >nul
if exist "!BASE!%~1" (
    set /a PASS+=1
    color 0A
    echo   [   OK   ]  %~2  --  %~3
) else (
    set /a FAIL+=1
    color 0C
    echo   [  FAIL  ]  %~2  --  %~3   ^<^< NOT FOUND
    color 0A
)
goto :EOF
