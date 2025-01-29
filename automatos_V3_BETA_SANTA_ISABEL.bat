@echo off
setlocal enabledelayedexpansion

:: Cabeçalho estilizado
cls
echo.
echo             __                 __
echo  ___  __ __/ /_ __  __ __ __ _/ /  __  ___
echo / _ `/ // / __/ _ \/  ' / _ `/ __/ _ \ \_
echo \_,_/\_,_/\__/\___/_/_/_\_,_/\__/\___/___/ V_3.0
echo.
:: Configuracoes iniciais
color 0A

:: Remover o mapeamento existente
echo [INFO] Desconectando a unidade de rede N:...
net use N: /delete /y >nul 2>&1
if %ERRORLEVEL% equ 0 (
    color 0A
    echo [SUCESSO] Unidade N: desconectada.
    color 0A
) else (
    color 0C
    echo [ERRO] Falha ao desconectar a unidade N:.
    color 0A
    pause
    exit /b
)

:: Mapear a nova unidade de rede
echo [INFO] Mapeando a unidade N: para \\10.17.228.180\ti...
net use N: "\\10.17.228.180\ti"
if %ERRORLEVEL% neq 0 (
    color 0C
    echo [ERRO] Falha ao mapear a unidade de rede. Verifique o caminho ou as credenciais.
    color 0A
    pause
    exit /b
)
echo [SUCESSO] Unidade N: mapeada com sucesso!

:: Copiar o arquivo para a area de trabalho do usuario
echo [INFO] Copiando o arquivo DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe...
copy "N:\Automatos\automatos\DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe" "%USERPROFILE%\Desktop" >nul 2>&1
if exist "%USERPROFILE%\Desktop\DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe" (
    color 0A
    echo [SUCESSO] Arquivo copiado para a area de trabalho.
    color 0A
) else (
    color 0C
    echo [ERRO] Falha ao copiar o arquivo. Verifique se o arquivo esta disponivel na unidade de rede.
    color 0A
    pause
    exit /b
)

:: Executar o arquivo copiado
echo [INFO] Executando o instalador DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe...
start "" "%USERPROFILE%\Desktop\DesktopAgent_V4.2.2_FHEMIG_Proxy_17_01_25.exe"
echo [INFO] Instalador iniciado. Aguarde a conclusao...

:: Aguardar ate que a pasta do Desktop Agent seja criada
echo [INFO] Aguardando criacao da pasta C:\Program Files (x86)\Automatos\Desktop Agent...
:verificar_pasta
if exist "C:\Program Files (x86)\Automatos\Desktop Agent" (
    color 0A
    echo [SUCESSO] Pasta do Desktop Agent criada.
    color 0A
) else (
    setlocal enabledelayedexpansion
    for %%a in ("Aguardando criacao da pasta / Instalacao #**   " "Aguardando criacao da pasta / Instalacao ##*  " "Aguardando criacao da pasta / Instalacao ### " "Aguardando criacao da pasta / Instalacao .   ") do (
        echo %%a
        timeout /t 1 >nul
        cls
    )
    goto verificar_pasta
)

:: Loop para reiniciar o adacontrol.exe
:reiniciar_loop
cls
echo [INFO] Deseja reiniciar o adacontrol.exe? (S para Sim, N para Nao)
set /p reiniciar="> "

if /i "%reiniciar%"=="S" (
    echo [INFO] Fechando adacontrol.exe...
    taskkill /f /im adacontrol.exe >nul 2>&1
    echo [INFO] Reiniciando adacontrol.exe...
    start "" "C:\Program Files (x86)\Automatos\Desktop Agent\adacontrol.exe"
    color 0A
    echo [SUCESSO] adacontrol.exe reiniciado.
    color 0A
    goto reiniciar_loop
) else if /i "%reiniciar%"=="N" (
    echo [INFO] Continuando o script...
) else (
    color 0C
    echo [ERRO] Opcao invalida. Digite 'S' para reiniciar ou 'N' para continuar.
    color 0A
    goto reiniciar_loop
)

:: Finalizar
cls
color 0A
echo.
echo ***************************************
echo *                                     *
echo *        INSTALACAO TERMINADA         *
echo *                                     *
echo ***************************************
echo.
echo [INFO] Processo concluido com sucesso.

:: Executar o script Hostname.bat no servidor
echo [INFO] Executando script Hostname.bat...
start "" "\\10.17.228.180\ti\Automatos\automatos\hostnames_unidades\hostname_santa_isabel.bat"
color 0A
echo [SUCESSO] Script Hostname.bat executado.
color 0A

pause
