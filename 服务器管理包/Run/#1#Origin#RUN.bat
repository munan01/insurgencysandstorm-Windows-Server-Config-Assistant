@echo off
chcp 65001 > nul

title 哈吉米1服

:: ============================================
::  自动定位
:: ============================================
set "PACK=%~dp0.."
set "ROOT=%~dp0..\.."
cd /d "%ROOT%"

:: ============================================
::  【配置开关】换玩法只改这两行
:: ============================================
set "MAP_SET=MapDayandNight"
set "GAMEINI_SET=#1#Origin#Game"

:: ============================================
::  创建目标目录
:: ============================================
if not exist "Insurgency\Config\Server"            mkdir "Insurgency\Config\Server"
if not exist "Insurgency\Saved\Config\WindowsServer" mkdir "Insurgency\Saved\Config\WindowsServer"

:: ============================================
::  部署全部配置文件
:: ============================================
copy /Y "%PACK%\Motd\#1#Origin#Motd.txt"   "Insurgency\Config\Server\#1#Origin#Motd.txt"  >nul
copy /Y "%PACK%\Admin\Admins.txt"          "Insurgency\Config\Server\Admins.txt"          >nul
copy /Y "%PACK%\Map\%MAP_SET%.txt"         "Insurgency\Config\Server\%MAP_SET%.txt"       >nul
copy /Y "%PACK%\Gameini\%GAMEINI_SET%.ini" "Insurgency\Saved\Config\WindowsServer\Game.ini" >nul

:: ============================================
::  启动服务器
:: ============================================
start "" InsurgencyServer.exe ^
 Ministry?Scenario_Ministry_Checkpoint_Insurgents?MaxPlayers=8 ^
 -Port=12317 ^
 -QueryPort=12318 ^
 -log ^
 -NoEAC ^
 -hostname="哈吉米1服 哈吉米之老吴之家[0.5]" ^
 -MapCycle=%MAP_SET% ^
 -AdminList=Admins ^
 -Motd=#1#Origin#Motd ^
 -GSLTToken=ABC645CF6D1349175C6F6B46B4208ABC ^
 -GameStatsToken=ABC6E10A25E54F1E840A75381977EABC

exit
