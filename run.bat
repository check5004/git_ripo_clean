@echo off
echo.
echo ===== Gitリポジトリの無視されたファイルを削除するスクリプト =====
echo.

set /p directoryPath="作業するディレクトリのパスを入力してください (空のままで現在のディレクトリ): "

if "%directoryPath%"=="" set directoryPath=%cd%

echo.
echo 入力されたディレクトリ: %directoryPath%
echo.

if not exist "%directoryPath%\*" (
    echo.
    echo 指定されたディレクトリは存在しません。
    echo.
    exit /b
)

if not exist "%directoryPath%\.git" (
    echo.
    echo 指定されたディレクトリはGitリポジトリではありません。
    echo.
    exit /b
)

echo このディレクトリで作業を進めてもよろしいですか？ (y/n)
set /p confirm=

if /I "%confirm%" neq "y" (
    echo.
    echo 処理を中止しました。
    echo.
    exit /b
)

echo.
echo 処理を開始します...
echo.

powershell -ExecutionPolicy Bypass -File "RemoveIgnoredFiles.ps1" -directoryPath "%directoryPath%"

echo.
echo 処理が完了しました。
echo.
