
# 沙暴服务器管理包 使用说明

>⚠️ **重要提示：**请务必先阅读官方指南并了解各项文件功能


## 一、目录结构

```
服务器管理包\
├─ ARS.bat                          ← 定时重启主控脚本
├─ InstallTask.bat                  ← 计划任务安装脚本（双击即装）
├─ Run\                             ← 启动脚本目录
│  ├─ #1#Origin#RUN.bat             ← 1服启动脚本
│  └─ #2#Mod#RUN.bat                ← 2服启动脚本
├─ ARSlog\                          ← 主控日志目录（自动创建）
│  └─ ARSTaskLog.txt                ← 记录备份/关服/启动全过程
├─ LogBackup\                       ← 日志备份目录（自动创建）
│  ├─ #1#Origin#log#2026-06-27-03-00-00.log
│  └─ #2#Mod#log#2026-06-27-03-00-00.log
├─ Motd\                            ← 服务器公告
│  ├─ #1#Origin#Motd.txt
│  └─ #2#Mod#Motd.txt
├─ Admin\                           ← 管理员名单
│  └─ Admins.txt
├─ Map\                             ← 地图池配置
│  ├─ MapDayandNight.txt
│  └─ MapOnlyDay.txt
└─ Gameini\                         ← 游戏规则配置
   ├─ #1#Origin#Game.ini
   └─ #2#Mod#Game.ini
```

---

## 二、各文件职责

| 文件 | 功能 |
|------|------|
| **ARS.bat** | 定时重启主控。流程：备份日志 → 关闭旧进程 → 间隔10秒依次启动1服和2服 |
| **InstallTask.bat** | 以管理员运行后，将 ARS.bat 注册为每天凌晨 3:00 执行的系统计划任务 |
| **Run\\#1#Origin#RUN.bat** | 1服启动脚本。自动部署配置并拉起服务器 |
| **Run\\#2#Mod#RUN.bat** | 2服启动脚本。自动部署配置并拉起服务器 |
| **ARSlog\\ARSTaskLog.txt** | 记录每次主控执行的时间点和各步骤成败 |
| **LogBackup\\** | 每次重启前将服务器运行日志备份到此，文件名含时间戳 |
| **Motd\\** | 存放服务器公告文本，启动时自动部署到服务器 |
| **Admin\\** | 存放 SteamID 格式的管理员列表 |
| **Map\\** | 存放地图池配置文件，启动时按需部署 |
| **Gameini\\** | 存放游戏规则配置，启动时按需部署 |

---

## 三、部署流程（新服务器开包即用）

### 1. 放置管理包

将 `服务器管理包` 整个文件夹复制到 `sandstorm_server` 目录下：

```
sandstorm_server\
├─ InsurgencyServer.exe
├─ Engine\
├─ Insurgency\
├─ ...其他游戏文件...
└─ 服务器管理包\          ← 放这里
```

### 2. 填写配置文件

在管理包对应目录中填入你的配置：

```
Motd\
  #1#Origin#Motd.txt         写1服公告内容
  #2#Mod#Motd.txt            写2服公告内容

Admin\
  Admins.txt                 每行一个 SteamID

Map\
  MapDayandNight.txt         此为哈基米系列服务器在行地图池，包含checkpoint模式日夜，Survival日
  MapOnlyDay.txt             此为哈基米系列服务器在行地图池，包含checkpoint模式日

Gameini\
  #1#Origin#Game.ini         1服游戏规则
  #2#Mod#Game.ini            2服游戏规则

Run\
  #1#Origin#Run.bat         1服启动脚本
  #2#Mod#Run.bat            2服启动脚本
```


### 3. 测试启动

修改`Run\#1#Origin#RUN.bat``Run\#2#Mod#RUN.bat`：
 - 修改 启动服务器 部分的以下参数
 ```
   -Port=12317 ^                                       调整游戏连接的 UDP 端口
   -QueryPort=12318 ^                                  Steam 运行服务器查询的端口
   -GSLTToken=ABC645CF6D1349175C6F6B46B4208087 ^       Steam GSLT令牌
   -GameStatsToken=ABC6E10A25E54F1E840A75381977EE86    GameStats 令牌
  ```

双击 `Run\#1#Origin#RUN.bat`：

- 脚本自动创建服务器所需的 `Insurgency\Config\Server\` 和 `Insurgency\Saved\Config\WindowsServer\` 目录
- 自动将 Motd、Admin、Map、Game.ini 部署到对应位置
- 在新窗口拉起 1 服

同样双击 `Run\#2#Mod#RUN.bat` 测试 2 服。

### 4. 安装计划任务

右键 `InstallTask.bat` → **以管理员身份运行**，即可创建每天凌晨 3:00 的自动重启任务。

如需调整执行时间，编辑 `InstallTask.bat` 第 26 行的 `/st 03:00` 后重新运行。

---

## 四、修改配置的方法

### 修改地图池

编辑 `Run\` 下对应启动脚本的【配置开关】区域：

```batch
set "MAP_SET=MapDayandNight"       ← 改为 MapOnlyDay 即可切换
set "GAMEINI_SET=#1#Origin#Game"   ← 改为其他 Game.ini 文件名
```

前提是 `Map\` 和 `Gameini\` 文件夹中已有对应文件。

### 修改服务器启动参数

编辑 `Run\` 下对应启动脚本的 `启动服务器` 行。1服和2服的核心参数已分开，互不影响。

### 修改主控行为

编辑 `ARS.bat`。所有路径均自动定位，换设备无需改任何路径。

---

## 五、日志说明

| 日志 | 位置 | 内容 |
|------|------|------|
| **主控日志** | `ARSlog\ARSTaskLog.txt` | 时间、备份成败、进程关闭、启动状态 |
| **历史日志** | `LogBackup\#1#Origin#log#yyyy-MM-dd-HH-mm-ss.log` | 重启前备份的1服运行日志 |
| **历史日志** | `LogBackup\#2#Mod#log#yyyy-MM-dd-HH-mm-ss.log` | 重启前备份的2服运行日志 |

---

## 六、计划任务管理

| 操作 | 命令 |
|------|------|
| 查看任务详情 | `schtasks /query /tn "ARS重启任务" /v` |
| 手动立即执行 | `schtasks /run /tn "ARS重启任务"` |
| 删除任务 | `schtasks /delete /tn "ARS重启任务" /f` |

也可在 Windows 搜索栏输入 `taskschd.msc` 打开图形界面管理。

---

## 七、注意事项

1. **路径含 `#` 字符**是沙暴服务器的启动参数规范，不影响 Windows 文件系统
2. `copy /Y` 每次启动都会覆盖服务器目录中的配置文件，**管理包中的文件是唯一真身**，修改配置请直接改管理包内的文件
3. 换设备/换路径时**无需修改任何脚本**，管理包自定位生效
4. 计划任务以 **SYSTEM 账户最高权限**运行，无论是否登录都会执行
5. `ARS.bat` 在关闭进程时若进程不存在则跳过，不会报错终止
