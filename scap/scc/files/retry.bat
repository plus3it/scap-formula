@echo off

set /a n=0
set /a try=%1

REM Get the command (everything except %1)
shift
set cmd=%1
:get_cmd
shift
if [%1]==[] goto got_cmd
set cmd=%cmd% %1
goto get_cmd
:got_cmd


echo Will try %try% time(s) :: %cmd%

:loop
IF %n% GEQ %try% (
    echo Command never succeeded :: %cmd%
    goto failure
)

timeout /nobreak /t %n% > nul
call %cmd% && goto success
set /a result=%ERRORLEVEL%
set /a n+=1
echo Attempt %n%, command failed :: %cmd%
goto loop

:success
exit /B

:failure
exit /B %result%
