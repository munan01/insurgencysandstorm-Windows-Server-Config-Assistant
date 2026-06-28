@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: ============================================
::  自动定位
:: ============================================
set "PACK=%~dp0"
set "ROOT=%~dp0.."

:: ============================================
::  配置区
:: ============================================
set "PROCESS=InsurgencyServer.exe"
set "LOG_PATH=%ROOT%\Insurgency\Saved\Logs"
set "BACKUP_PATH=%PACK%LogBackup"
set "LOG_FILE=%PACK%ARSlog\ARSTaskLog.txt"
set "B1=%PACK%Run\#1#Origin#RUN.bat"
set "B2=%PACK%Run\#2#Mod#RUN.bat"

:: ============================================
::  生成时间戳 (yyyy-MM-dd-HH-mm-ss)
:: ============================================
set "ts=%date:~0,4%-%date:~5,2%-%date:~8,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "ts=%ts: =0%"

:: ============================================
::  步骤 1：备份日志文件
:: ============================================
if not exist "%PACK%ARSlog" mkdir "%PACK%ARSlog"

echo %date% %time% ========== 开始执行 ========== >> "%LOG_FILE%"
echo %date% %time% [备份] 开始备份日志... >> "%LOG_FILE%"

if not exist "%BACKUP_PATH%" mkdir "%BACKUP_PATH%"

if exist "%LOG_PATH%\Insurgency.log" (
    copy /y "%LOG_PATH%\Insurgency.log" "%BACKUP_PATH%\#1#Origin#log#%ts%.log" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %date% %time% [备份] Insurgency.log → #1#Origin#log#%ts%.log 成功 >> "%LOG_FILE%"
    ) else (
        echo %date% %time% [备份] Insurgency.log 备份失败, 错误码 !errorlevel! >> "%LOG_FILE%"
    )
) else (
    echo %date% %time% [备份] Insurgency.log 不存在, 跳过 >> "%LOG_FILE%"
)

if exist "%LOG_PATH%\Insurgency_2.log" (
    copy /y "%LOG_PATH%\Insurgency_2.log" "%BACKUP_PATH%\#2#Mod#log#%ts%.log" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %date% %time% [备份] Insurgency_2.log → #2#Mod#log#%ts%.log 成功 >> "%LOG_FILE%"
    ) else (
        echo %date% %time% [备份] Insurgency_2.log 备份失败, 错误码 !errorlevel! >> "%LOG_FILE%"
    )
) else (
    echo %date% %time% [备份] Insurgency_2.log 不存在, 跳过 >> "%LOG_FILE%"
)

:: ============================================
::  步骤 2：关闭指定进程（不存在则跳过）
:: ============================================
tasklist /fi "imagename eq %PROCESS%" 2>nul | find /i "%PROCESS%" >nul 2>&1
if !errorlevel! equ 0 (
    echo %date% %time% [进程] 发现 %PROCESS%, 正在关闭... >> "%LOG_FILE%"
    taskkill /f /t /im "%PROCESS%" >nul 2>&1
    if !errorlevel! equ 0 (
        echo %date% %time% [进程] %PROCESS% 已成功关闭 >> "%LOG_FILE%"
    ) else (
        echo %date% %time% [进程] %PROCESS% 关闭失败, 错误码 !errorlevel! >> "%LOG_FILE%"
    )
) else (
    echo %date% %time% [进程] %PROCESS% 未运行, 跳过关闭流程 >> "%LOG_FILE%"
)

:: ============================================
::  步骤 3：启动脚本 #1，10秒后启动脚本 #2
:: ============================================

echo %date% %time% [启动] 执行脚本 "!B1!" >> "%LOG_FILE%"
start "" /d "%ROOT%" "!B1!"
echo %date% %time% [启动] 脚本#1 已启动 >> "%LOG_FILE%"

echo %date% %time% [等待] 10秒后启动脚本#2... >> "%LOG_FILE%"
timeout /t 10 /nobreak >nul

echo %date% %time% [启动] 执行脚本 "!B2!" >> "%LOG_FILE%"
start "" /d "%ROOT%" "!B2!"
echo %date% %time% [启动] 脚本#2 已启动 >> "%LOG_FILE%"

echo %date% %time% ========== 全部完成 ========== >> "%LOG_FILE%"
