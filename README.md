# Gitリポジトリの無視されたファイルを削除するスクリプト

このドキュメントでは、Gitリポジトリから無視されているが追跡されているファイルを削除するためのバッチファイル(`run.bat`)とPowerShellスクリプト(`RemoveIgnoredFiles.ps1`)について説明します。

## 概要

このスクリプトは、`.gitignore`に記載されているにも関わらず、誤って追跡されてしまっているファイルをGitリポジトリから削除します。削除されたファイルのリストはユーザーのダウンロードフォルダにテキストファイルとして保存され、自動的に開かれます。また、処理の詳細はログファイルに記録されます。

## 使用方法

1. `run.bat`をダブルクリックして実行します。
2. 作業するディレクトリのパスを入力します。何も入力せずにEnterを押すと、現在のディレクトリが使用されます。
3. スクリプトがディレクトリを確認し、Gitリポジトリであることを検証します。
4. 処理を続行するかどうかを尋ねられます。`y`を入力してEnterを押すと、処理が開始されます。
5. 処理が完了すると、削除されたファイルのリストがダウンロードフォルダに保存され、自動的に開かれます。処理の詳細はログファイルに記録されます。

## スクリプトの詳細

- `run.bat`: ユーザーからの入力を受け取り、条件を検証した後、`RemoveIgnoredFiles.ps1`を呼び出します。

- `RemoveIgnoredFiles.ps1`: 実際に`.gitignore`に記載されているが追跡されているファイルを見つけ出し、削除します。削除されたファイルのリストはユーザーのダウンロードフォルダに保存され、処理の詳細はログファイルに記録されます。

## 注意事項

- このスクリプトは、Windows環境でのみ動作します。
- Gitがインストールされている必要があります。
- PowerShellの実行ポリシーによっては、スクリプトの実行を許可する必要がある場合があります。

<br><br><br><br>

# Script to Remove Ignored Files from a Git Repository

This document describes a batch file (`run.bat`) and a PowerShell script (`RemoveIgnoredFiles.ps1`) for removing files that are ignored but tracked in a Git repository.

## Overview

This script removes files that are mistakenly tracked in a Git repository despite being listed in `.gitignore`. The list of removed files is saved as a text file in the user's download folder and is automatically opened. Additionally, the details of the process are recorded in a log file.

## How to Use

1. Double-click `run.bat` to execute it.
2. Enter the path of the directory you want to work in. If you press Enter without entering anything, the current directory will be used.
3. The script checks the directory and verifies that it is a Git repository.
4. You will be asked whether to proceed with the process. Press `y` and then Enter to start the process.
5. Once the process is complete, the list of removed files will be saved in the download folder and automatically opened. The details of the process are recorded in a log file.

## Script Details

- `run.bat`: Receives input from the user, verifies the conditions, and then calls `RemoveIgnoredFiles.ps1`.

- `RemoveIgnoredFiles.ps1`: Identifies and removes files that are listed in `.gitignore` but are still being tracked. The list of removed files is saved in the user's download folder, and the details of the process are recorded in a log file.

## Notes

- This script only works in a Windows environment.
- Git must be installed.
- Depending on the execution policy of PowerShell, you may need to allow the script to run.