@echo off
setlocal EnableDelayedExpansion
title #define everything

echo === definition of everything ===
set /p "DEFLINE=#define "

if not defined DEFLINE (
    echo No definition given. Nothing is everything. Bye.
    pause
    exit /b
)

rem --- split "name body" into MACRO and BODY ---
for /f "tokens=1* delims= " %%A in ("%DEFLINE%") do (
    set "MACRO=%%A"
    set "BODY=%%B"
)

if "%MACRO%"=="" (
    echo Malformed #define. Usage: #define NAME BODY
    pause
    exit /b
)
if not defined BODY (
    echo [#define everything] "%MACRO%" defined as empty macro.
) else (
    echo [#define everything] "%MACRO%" => %BODY%
)

echo.
echo [OK] "%MACRO%" is now defined. Type it to expand the macro.
echo      Type "exit" to quit.
echo.

:listen
set "INPUT="
set /p "INPUT=%MACRO%> "
if not defined INPUT goto listen

rem --- extract first token and the rest ---
set "FIRST="
set "REST="
for /f "tokens=1* delims= " %%A in ("%INPUT%") do (
    set "FIRST=%%A"
    set "REST=%%B"
)

rem --- hijack check ---
if /i "%FIRST%"=="%MACRO%" goto expand
if /i "%FIRST%"=="exit"    goto :eof
if /i "%FIRST%"=="quit"    goto :eof

rem --- pass-through ---
%INPUT%
goto listen

:expand
echo [ #define everything ] expanding "%MACRO%" -^> "%BODY% %REST%"
if defined REST (
    %BODY% %REST%
) else (
    %BODY%
)
goto listen