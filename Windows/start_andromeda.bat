@ECHO OFF

ECHO Andromeda Start Script by [projekt.] development team
ECHO.
ECHO This requires Andromeda and Substratum installed on the device
ECHO Make sure the device is connected and ADB option enabled
ECHO Please only have one device connected at a time to use this!
ECHO.
PAUSE
CLS
SET ROOT=%~dp0
SET SCRIPT=device_script.sh
SET SCRIPT_DESTINATION=/data/local/tmp

REM start ADB server
adb kill-server
adb start-server

REM get package path
FOR /f "delims=" %%i IN ('adb shell pm path projekt.andromeda') DO SET packagepath=%%i
SET packagepath=%packagepath:~8%

REM check if andromeda is running
FOR /f "delims=" %%i IN ('adb shell pidof andromeda') DO SET pid=%%i

ECHO Moving the the main script...
adb push %SCRIPT% %SCRIPT_DESTINATION%

ECHO Starting the the main script...

IF [%pid%] == [] GOTO ADM
(@echo.am force-stop projekt.substratum
@echo.kill -9 %pid%
@echo.appops set projekt.andromeda RUN_IN_BACKGROUND allow
@echo.appops set projekt.substratum RUN_IN_BACKGROUND allow
@echo.chmod +x %SCRIPT_DESTINATION%/%SCRIPT%
@echo.sh %SCRIPT_DESTINATION%/%SCRIPT%
@echo.rm -rf %SCRIPT_DESTINATION%/%SCRIPT%
@echo.exit
) | adb shell
ECHO Script finished.
PAUSE
EXIT

:ADM
(@echo.am force-stop projekt.substratum
@echo.appops set projekt.andromeda RUN_IN_BACKGROUND allow
@echo.appops set projekt.substratum RUN_IN_BACKGROUND allow
@echo.chmod +x %SCRIPT_DESTINATION%/%SCRIPT%
@echo.sh %SCRIPT_DESTINATION%/%SCRIPT%
@echo.rm -rf %SCRIPT_DESTINATION%/%SCRIPT%
@echo.exit
) | adb shell
ECHO Script finished.
EXIT

REM We're done!
adb kill-server