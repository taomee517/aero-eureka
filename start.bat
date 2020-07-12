@echo off
 
::默认PID，无需修改
set PID="999999"

::记录当前目录，无需修改
set CURRENT_PATH="%~dp0"
 
::指定程序工作路径
set SERVICE_DIR="%~dp0"
::指定jar包
set JARNAME="%~dp0\aero-eureka-1.0-SNAPSHOT.jar"
::指定程序端口号
set port="8777"
::指定程序启动日志名
set LOG_FILE="startup.log"
 
 
 
::流程控制
if "%1"=="start" (
  call:START
) else (
  if "%1"=="stop" ( 
    call:STOP 
  ) else ( 
    if "%1"=="restart" (
	  call:RESTART 
	) else ( 
	  call:DEFAULT 
	)
  )
)
goto:eof
 
 
::启动jar包
:START
echo function "start" starting...
cd /d %SERVICE_DIR%

::项目已经打包好，无须再编译
::call %MAVEN_HOME_CUSTOM%\bin\mvn clean install

echo %JARNAME%
start /b "%JAVA_HOME%\bin\" javaw.exe -Xms256m -Xmx1024m -jar %JARNAME%

::日志输出到指定日志文件，暂时不用输出到startup.log
::> %SERVICE_DIR%\%LOG_FILE%

cd /d %CURRENT_PATH%
echo == service start success
goto:eof
 
 
::停止java程序运行
:STOP
echo function "stop" starting...
call:findPid
call:shutdown
echo == service stop success
goto:eof
 
 
::重启jar包
:RESTART
echo function "restart" starting...
call:STOP
call:sleep2
call:START
echo == service restart success
goto:eof
 
 
::执行默认方法--重启jar包
:DEFAULT
echo Now choose default item : restart
call:STOP
call:sleep2
call:START
echo == service restart success
goto:eof
 
 
::找到端口对应程序的pid
:findPid
echo function "findPid" start.
for /f "tokens=5" %%i in ('netstat -aon ^| findstr %port%') do (
    set "PID=%%i"
)
if "%PID%"=="999999" ( echo pid not find, skip stop . ) else ( echo pid is %PID%. )
goto:eof
 
 
::杀死pid对应的程序
:shutdown
if not "%PID%"=="999999" ( taskkill /f /pid %PID% )
goto:eof
 
 
::延时5秒
:sleep5
ping 127.0.0.1 -n 5 >nul
goto:eof
 
 
::延时2秒
:sleep2
ping 127.0.0.1 -n 2 >nul
goto:eof

exit
