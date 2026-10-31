@echo off
setlocal
title Number Guessing Game v5
mode con: cols=64 lines=30

:: ---- ANSI colours (plain text fallback if unsupported) ----
set "ESC="
for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "RESET=" & set "BOLD=" & set "RED=" & set "GREEN=" & set "YELLOW="
set "BLUE=" & set "MAGENTA=" & set "CYAN=" & set "WHITE=" & set "GRAY="
if defined ESC (
    set "RESET=%ESC%[0m"
    set "BOLD=%ESC%[1m"
    set "RED=%ESC%[91m"
    set "GREEN=%ESC%[92m"
    set "YELLOW=%ESC%[93m"
    set "BLUE=%ESC%[94m"
    set "MAGENTA=%ESC%[95m"
    set "CYAN=%ESC%[96m"
    set "WHITE=%ESC%[97m"
    set "GRAY=%ESC%[90m"
)

:NEWGAME
cls
echo.
echo   %CYAN%+==========================================================+%RESET%
echo   %CYAN%^|%RESET%                                                          %CYAN%^|%RESET%
echo   %CYAN%^|%RESET%      %BOLD%%YELLOW%*  N U M B E R   G U E S S I N G   G A M E  *%RESET%      %CYAN%^|%RESET%
echo   %CYAN%^|%RESET%                                                          %CYAN%^|%RESET%
echo   %CYAN%+==========================================================+%RESET%
echo.
echo   %WHITE%I'm thinking of a number between %GREEN%1%WHITE% and %GREEN%100%WHITE%.%RESET%
echo   %WHITE%Can you guess it? I'll tell you if you're too high or low.%RESET%
echo.
echo   %CYAN%------------------------------------------------------------%RESET%
echo.

:: Random number between 1 and 100
set /a "randomNumber=%RANDOM% %% 100 + 1"
set /a "no_of_guesses=0"

:GUESS
set "guess="
set /p "guess=  %MAGENTA%>>%RESET% %BOLD%Guess the number : %RESET%"
if not defined guess goto INVALID

:: Reject anything that contains a character other than digits/spaces
for /f "delims=0123456789 " %%a in ("%guess%") do goto INVALID

:: Remove leading zeros (so 08 is not read as octal)
for /f "tokens=* delims=0" %%z in ("%guess%") do set "guess=%%z"

:: Convert to a number; anything that fails stays 0
set /a "num=0"
set /a "num=%guess%" 2>nul
if %num% LSS 1 goto INVALID
if %num% GTR 100 goto INVALID

set /a "no_of_guesses+=1"

if %num% GTR %randomNumber% goto TOOHIGH
if %num% LSS %randomNumber% goto TOOLOW
goto WIN

:TOOHIGH
echo      %RED%v  Lower number please!%RESET%
echo.
goto GUESS

:TOOLOW
echo      %BLUE%^^  Higher number please!%RESET%
echo.
goto GUESS

:INVALID
echo      %YELLOW%!  Please enter a whole number from 1 to 100.%RESET%
<nul set /p "=%GRAY%     (received: "
set guess 2>nul || <nul set /p "=nothing"
echo ^)%RESET%
echo.
goto GUESS

:WIN
echo.
echo   %GREEN%+==========================================================+%RESET%
echo   %GREEN%^|%RESET%                                                          %GREEN%^|%RESET%
echo   %GREEN%^|%RESET%              %BOLD%%YELLOW%*  *  C O N G R A T S ! !  *  *%RESET%              %GREEN%^|%RESET%
echo   %GREEN%^|%RESET%                                                          %GREEN%^|%RESET%
echo   %GREEN%+==========================================================+%RESET%
echo.
echo   %WHITE%The number was %BOLD%%GREEN%%randomNumber%%RESET%%WHITE%.%RESET%
echo   %WHITE%You guessed the number in %BOLD%%YELLOW%%no_of_guesses%%RESET%%WHITE% guesses.%RESET%
echo.
echo   %CYAN%------------------------------------------------------------%RESET%
echo.

:AGAIN
set "again="
set /p "again=  %MAGENTA%>>%RESET% Play again? (%GREEN%Y%RESET%/%RED%N%RESET%) : "
if /i "%again%"=="Y" goto NEWGAME
if /i "%again%"=="N" goto END
goto AGAIN

:END
echo.
echo   %CYAN%Thanks for playing! Goodbye.%RESET%
echo.
timeout /t 2 >nul
endlocal
exit /b
