@echo off
 
::Ĭ��PID�������޸�
set "PID=999999"

::��¼��ǰĿ¼�������޸�
set "CURRENT_PATH=%~dp0"
 
::ָ��������·��
set "SERVICE_DIR=%CURRENT_PATH%"
::ָ��jar��
set "JARNAME=aero-eureka-1.0-SNAPSHOT.jar"
::ָ������˿ں�
set "port=8761"
::ָ������������־��
set "LOG_FILE=startup.log"
 
 
 
::���̿���
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
 
 
::����jar��
:START
echo function "start" starting...
cd /d %SERVICE_DIR%

::��Ŀ�Ѿ�����ã������ٱ���
::call %MAVEN_HOME_CUSTOM%\bin\mvn clean install
echo %SERVICE_DIR%\%JARNAME%
start /b "%JAVA_HOME%\bin\" javaw.exe -Xms256m -Xmx1024m -jar %SERVICE_DIR%\%JARNAME%

::��־�����ָ����־�ļ�����ʱ���������startup.log
::> %SERVICE_DIR%\%LOG_FILE%

cd /d %CURRENT_PATH%
echo == service start success
goto:eof
 
 
::ֹͣjava��������
:STOP
echo function "stop" starting...
call:findPid
call:shutdown
echo == service stop success
goto:eof
 
 
::����jar��
:RESTART
echo function "restart" starting...
call:STOP
call:sleep2
call:START
echo == service restart success
goto:eof
 
 
::ִ��Ĭ�Ϸ���--����jar��
:DEFAULT
echo Now choose default item : restart
call:STOP
call:sleep2
call:START
echo == service restart success
goto:eof
 
 
::�ҵ��˿ڶ�Ӧ�����pid
:findPid
echo function "findPid" start.
for /f "tokens=5" %%i in ('netstat -aon ^| findstr %port%') do (
    set "PID=%%i"
)
if "%PID%"=="999999" ( echo pid not find, skip stop . ) else ( echo pid is %PID%. )
goto:eof
 
 
::ɱ��pid��Ӧ�ĳ���
:shutdown
if not "%PID%"=="999999" ( taskkill /f /pid %PID% )
goto:eof
 
 
::��ʱ5��
:sleep5
ping 127.0.0.1 -n 5 >nul
goto:eof
 
 
::��ʱ2��
:sleep2
ping 127.0.0.1 -n 2 >nul
goto:eof

exit
