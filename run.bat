@echo off
echo.
echo ===== Git���|�W�g���̖������ꂽ�t�@�C�����폜����X�N���v�g =====
echo.

set /p directoryPath="��Ƃ���f�B���N�g���̃p�X����͂��Ă������� (��̂܂܂Ō��݂̃f�B���N�g��): "

if "%directoryPath%"=="" set directoryPath=%cd%

echo.
echo ���͂��ꂽ�f�B���N�g��: %directoryPath%
echo.

if not exist "%directoryPath%\*" (
    echo.
    echo �w�肳�ꂽ�f�B���N�g���͑��݂��܂���B
    echo.
    exit /b
)

if not exist "%directoryPath%\.git" (
    echo.
    echo �w�肳�ꂽ�f�B���N�g����Git���|�W�g���ł͂���܂���B
    echo.
    exit /b
)

echo ���̃f�B���N�g���ō�Ƃ�i�߂Ă���낵���ł����H (y/n)
set /p confirm=

if /I "%confirm%" neq "y" (
    echo.
    echo �����𒆎~���܂����B
    echo.
    exit /b
)

echo.
echo �������J�n���܂�...
echo.

powershell -ExecutionPolicy Bypass -File "RemoveIgnoredFiles.ps1" -directoryPath "%directoryPath%"

echo.
echo �������������܂����B
echo.
