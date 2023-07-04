@echo off
chcp 65001 >nul

set "git_installed="
set "python_installed="

rem 检查Git是否安装
where git >nul 2>&1
if %errorlevel% equ 0 (
    set "git_installed=true"
) else (
    set "git_installed=false"
)

rem 检查Python 3.10是否安装
where python >nul 2>&1
if %errorlevel% equ 0 (
    python --version 2>&1 | findstr /C:"Python 3.10" >nul 2>&1
    if %errorlevel% equ 0 (
        set "python_installed=true"
    ) else (
        set "python_installed=false"
    )
) else (
    set "python_installed=false"
)

rem 安装Git
if "%git_installed%"=="false" (
    echo Git未安装。正在安装Git...
    echo.
    rem 下载Git安装程序并安装
    powershell -Command "Invoke-WebRequest -Uri 'https://gitforwindows.org/' -OutFile 'git-installer.exe'"
    start /wait git-installer.exe /SILENT
    del git-installer.exe

    where git >nul 2>&1
    if %errorlevel% equ 0 (
        echo Git安装成功。
    ) else (
        echo Git安装失败。
        exit /b 1
    )
) else (
    echo Git已安装。
)

rem 安装Python 3.10
if "%python_installed%"=="false" (
    echo Python 3.10未安装。正在安装Python 3.10...
    echo.
    rem 下载Python 3.10安装程序并安装
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe' -OutFile 'python-installer.exe'"
    start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    del python-installer.exe

    where python >nul 2>&1
    if %errorlevel% equ 0 (
        python --version 2>&1 | findstr /C:"Python 3.10" >nul 2>&1
        if %errorlevel% equ 0 (
            echo Python 3.10安装成功。
        ) else (
            echo Python 3.10安装失败。
            exit /b 1
        )
    ) else (
        echo Python 3.10安装失败。
        exit /b 1
    )
) else (
    echo Python 3.10已安装。
)

echo 所有依赖已安装

set PYTHON=
set GIT=
set VENV_DIR=
set COMMANDLINE_ARGS=

call webui.bat