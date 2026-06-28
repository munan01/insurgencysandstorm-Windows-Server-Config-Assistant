@echo off
chcp 65001 > nul
:: ============================================
::  安装计划任务 — 每天凌晨 3:00 运行 ARS.bat
:: ============================================

:: ----- 自动提权 -----
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ----- 配置 -----
set "TASK_NAME=ARS重启任务"
set "SCRIPT_PATH=%~dp0ARS.bat"

:: ----- 存在性检查 -----
if not exist "%SCRIPT_PATH%" (
    echo [错误] 未找到 ARS.bat
    echo 预期位置: %SCRIPT_PATH%
    echo 请将本脚本与 ARS.bat 放在同一目录
    pause
    exit /b 1
)

:: ----- 创建计划任务 -----
schtasks /create /tn "%TASK_NAME%" /tr "\"%SCRIPT_PATH%\"" /sc daily /st 03:00 /ru SYSTEM /rl HIGHEST /f

if %errorlevel% equ 0 (
    echo [成功] 计划任务 "%TASK_NAME%" 已创建
    echo   执行文件: %SCRIPT_PATH%
    echo   执行时间: 每天 03:00
    echo   运行账户: SYSTEM
) else (
    echo [失败] 创建计划任务失败，错误码 %errorlevel%
)

pause
