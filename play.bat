@echo off
ml /c /coff main.asm
if %errorlevel% neq 0 (
    echo "ml failed!"
    exit /b %errorlevel%
)

link /subsystem:windows main.obj

if %errorlevel% neq 0 (
    echo "link failed!"
    exit /b %errorlevel%
)
main.exe
