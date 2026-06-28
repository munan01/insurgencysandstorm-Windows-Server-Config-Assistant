@echo off
chcp 65001 > nul

title 哈吉米2服

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
set "GAMEINI_SET=#2#Mod#Game"

:: ============================================
::  创建目标目录
:: ============================================
if not exist "Insurgency\Config\Server"            mkdir "Insurgency\Config\Server"
if not exist "Insurgency\Saved\Config\WindowsServer" mkdir "Insurgency\Saved\Config\WindowsServer"

:: ============================================
::  部署全部配置文件
:: ============================================
copy /Y "%PACK%\Motd\#2#Mod#Motd.txt"      "Insurgency\Config\Server\#2#Mod#Motd.txt"     >nul
copy /Y "%PACK%\Admin\Admins.txt"          "Insurgency\Config\Server\Admins.txt"          >nul
copy /Y "%PACK%\Map\%MAP_SET%.txt"         "Insurgency\Config\Server\%MAP_SET%.txt"       >nul
copy /Y "%PACK%\Gameini\%GAMEINI_SET%.ini" "Insurgency\Saved\Config\WindowsServer\Game.ini" >nul

:: ============================================
::  启动服务器
:: ============================================
start "" InsurgencyServer.exe ^
 Ministry?Scenario_Ministry_Checkpoint_Insurgents?MaxPlayers=8 ^
 -Port=12300 ^
 -QueryPort=12302 ^
 -log ^
 -hostname="哈吉米2服 哈吉米之踩背之家[0.5][WMS]" ^
 -NoEAC ^
 -MapCycle=%MAP_SET% ^
 -AdminList=Admins ^
 -Motd=#2#Mod#Motd ^
 -GSLTToken=ABCAE73D03FB9BA3D07FDE3554091ABC ^
 -GameStatsToken=ABC6841A46D440B49BF2B57F7005FABC ^
 -mods ^
 -ModDownloadTravelTo=Farmhouse?Scenario=Scenario_Farmhouse_Checkpoint_Security?Lighting=Day ^
 -SecurityCode=none ^
 -mutators=NorincoW02,Medicon

exit
