@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ==================================================
echo   Bully Proper Edition Fullscreen Fixes
echo ==================================================
echo.

set "found=0"
set "regPath=HKCU\System\GameConfigStore\Children"
set "targetExe=bully.exe"

echo Searching for %targetExe% in the Windows Registry...

:: Iterate through all subkeys inside GameConfigStore\Children
for /f "delims=" %%k in ('reg query "%regPath%" 2^>nul') do (
    :: Check if the current subkey belongs to bully.exe
    reg query "%%k" /v MatchedExeFullPath 2>nul | find /i "%targetExe%" >nul
    if !errorlevel! equ 0 (
        set "found=1"
        echo.
        echo [OK] Game found in the registry:
        echo Key: %%k
        
        echo Applying Flag 211 (Forcing Fullscreen Exclusive)...
        :: Set the Flags value to 211 (Decimal), overwriting if it exists
        reg add "%%k" /v Flags /t REG_DWORD /d 211 /f >nul
        
        if !errorlevel! equ 0 (
            echo [SUCCESS] Flag 211 applied successfully.
        ) else (
            echo [ERROR] Failed to apply the flag. Please close and run this script as Administrator.
        )
    )
)

:: If the loop finishes and the game is not found, display instructions
if "!found!"=="0" (
    echo.
    echo [WARNING] %targetExe% was not found in the GameConfigStore.
    echo.
    echo Windows hasn't registered the game yet. To fix this:
    echo 1. Launch Bully normally.
    echo 2. Close the game.
    echo 3. Run this script again.
)

echo.
pause