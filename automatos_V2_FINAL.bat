@echo off
title Mapeamento e Execucao de Desktop Agent
cls

REM Remover o mapeamento existente
echo Desconectando a unidade de rede N:...
color 0C
net use N: /delete /y
echo Unidade N: desconectada com sucesso!
color 07
echo.

REM Mapeando a nova unidade de rede com o nome 'ti'
echo Mapeando a unidade N: para \\10.17.228.180\ti...
net use N: "\\10.17.228.180\ti"
if %ERRORLEVEL% neq 0 (
    echo Falha ao mapear a unidade de rede. Verifique o caminho ou as credenciais.
    pause
    exit /b
)
echo Unidade de rede N: mapeada com sucesso!
echo.

REM Copiar o arquivo para a maquina do usuario (alterar caminho de destino conforme necessario)
color 0A
echo Copiando o arquivo "DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe" para a area de trabalho...
copy "N:\Automatos\automatos\DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe" "%USERPROFILE%\Desktop"
if exist "%USERPROFILE%\Desktop\DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe" (
    echo Arquivo copiado com sucesso para a area de trabalho!
) else (
    echo Falha ao copiar o arquivo. Verifique se o arquivo esta disponivel na unidade de rede.
    pause
    exit /b
)
color 07
echo.

REM Executar o arquivo copiado
color 0A
echo Executando o arquivo DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe...
start "" "%USERPROFILE%\Desktop\DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe"
echo O instalador foi iniciado. A instalacao pode levar alguns minutos. Aguarde...
color 07
echo.

REM Aguardar ate que a pasta C:\Program Files (x86)\Automatos\Desktop Agent seja criada
echo Aguardando a criacao da pasta "C:\Program Files (x86)\Automatos\Desktop Agent"... 
:verificar_pasta
if exist "C:\Program Files (x86)\Automatos\Desktop Agent" (
    echo Pasta encontrada! Continuando...
) else (
    timeout /t 1 >nul
    goto verificar_pasta
)
echo.

REM Abrir a pasta C:\Program Files (x86)\Automatos\Desktop Agent
echo Abrindo a pasta "C:\Program Files (x86)\Automatos\Desktop Agent"...
start "" "C:\Program Files (x86)\Automatos\Desktop Agent"
echo.

REM Executar o adacontrol.exe
echo Executando o adacontrol.exe...
start "" "C:\Program Files (x86)\Automatos\Desktop Agent\adacontrol.exe"
echo.

REM Finalizar
color 0A
echo O processo foi concluido com sucesso!
echo.

REM Pausar
pause

REM Agora, escutar e executar o script Inv 7_11.bat localizado no servidor
echo Executando o script Inv 7_11.bat...
start "" "\\10.17.228.180\ti\Automatos\automatos\hostname.bat"

echo Script Inv 7_11.bat executado com sucesso!
