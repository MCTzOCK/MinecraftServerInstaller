@echo off
::init
set product_name=Minecraft Server Installer
set product_version=1.0
set product_author=MCTzOCK
set product_installer_path=%appdata%\MinecraftServers
title %product_name% v%product_version% by %product_author%
if not exist %product_installer_path% (
    mkdir %product_installer_path%;
)
cls
echo.
echo Welcome to %product_name%
echo ATTENTION: By using this tool you accept to the Minecraft eula (https://account.mojang.com/documents/minecraft_eula)
goto main

:main
echo.
echo What do you want to do?
echo.
echo [1] Create a new Server
echo [2] Delete a Server
echo [3] Start a Server
echo.
set /p o=Enter a number from the list above:
if "%o%" == "1" (
    goto createserver
) else if "%o%" == "2" (
    goto deleteserver
) else if "%o%" == "3" (
    goto startserver
) else (
    goto error
)

:createserver
cls
echo.
echo Create a new Server
echo.
set /p name=Enter a Name for the Server(type 'c' to cancel):
if "%name%" == "c" (
    cls
    goto main
) else (
    if not exist %product_installer_path%\%name% (
        mkdir %product_installer_path%\%name%
    ) else (
        cls
        echo.
        echo Error this Server does already exist!
        echo.
        goto main
    )
)
echo.
echo Choose a server Version!
echo.
set /p version=Enter the Spigot Version you want to install (e.g. 1.16.4):
echo.
echo Downloading...
mkdir %product_installer_path%\%name%\temp
powershell.exe Invoke-WebRequest -Uri https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -OutFile %product_installer_path%\%name%\temp\BuildTools.jar
powershell.exe Invoke-WebRequest -Uri https://raw.githubusercontent.com/MCTzOCK/MinecraftServerInstaller/main/defaults/start.bat -OutFile %product_installer_path%\%name%\start.bat
cd %product_installer_path%\%name%\temp
cls
echo.
echo Building Spigot...
echo.
::compile
java -jar BuildTools.jar --rev %version%
copy spigot-%version%.jar ..\server.jar
cd ..
::accept eula
echo eula=true> eula.txt
cls
echo.
echo The Installation Process is finished! You can now start your server!
echo.
goto main

:deleteserver
cls
echo.
echo Delete a Server
echo.
set /p name=Enter the name of the Server you want to delete:
set /p y=Are you sure you want to delete %name% (this cant be undoed) [y/N]:
if "%y%" == "y" (
    if exist %product_installer_path%\%name% (
        rmdir /S /Q %product_installer_path%\%name%
        cls
        echo.
        echo Deleted!
        echo.
        goto main
    ) else (
        cls
        echo.
        echo Error! This Server does not exist!
        echo.
        goto main
    )
) else (
    cls
    echo.
    echo Abort.
    echo.
    goto main
)

:startserver
cls
echo.
echo Start a Server
echo.
set /p name=Enter the name of the Server:
if exist %product_installer_path%\%name%\server.jar (
    cd %product_installer_path%\%name%
    start start.bat
    cls
    goto main
) else (
    echo.
    echo Error! Server.jar file was not found in %product_installer_path%\%name%! Try creating a server!
    echo.
    goto main
)

:error
cls
echo Abort.
goto main

:end
cls
echo.
echo [Program Exited]
pause > nul