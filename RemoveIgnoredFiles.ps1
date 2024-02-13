param (
  [string]$directoryPath
)

# ログファイルのパスを設定
$shellapp = New-Object -ComObject Shell.Application
$logFolder = $shellapp.Namespace("shell:Downloads").Self.Path
$logPath = Join-Path $logFolder ("GitCleanupLog_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")

# 指定されたディレクトリに移動
cd $directoryPath

# リポジトリ内の全追跡ファイルを取得し、ファイルに出力
$trackedFiles = git ls-files --cached
$trackedFilesPath = Join-Path $logFolder ("TrackedFiles_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")
$trackedFiles | Out-File -FilePath $trackedFilesPath
echo "追跡されているファイルのリストはこちらに保存されました: $trackedFilesPath" | Out-File -FilePath $logPath -Append

# .gitignoreで無視されるべきファイルを特定し、ファイルに出力
$ignoredFiles = git ls-files --others --ignored --exclude-standard
$ignoredFilesPath = Join-Path $logFolder ("IgnoredFiles_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")
$ignoredFiles | Out-File -FilePath $ignoredFilesPath
echo "無視されるべきファイルのリストはこちらに保存されました: $ignoredFilesPath" | Out-File -FilePath $logPath -Append

# 削除されたファイルのリストを保存するための変数
$removedFiles = @()

# .gitignoreで指定されているが追跡されているファイルを特定
$ignoredButTrackedFiles = git ls-files --cached --ignored --exclude-standard
$ignoredButTrackedFilesPath = Join-Path $logFolder ("IgnoredButTrackedFiles_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")
$ignoredButTrackedFiles | Out-File -FilePath $ignoredButTrackedFilesPath
echo "無視されるべきが追跡されているファイルのリストはこちらに保存されました: $ignoredButTrackedFilesPath" | Out-File -FilePath $logPath -Append

# それらのファイルをキャッシュから削除
foreach ($file in $ignoredButTrackedFiles) {
  #@ [test] Appディレクトリ内のファイルは削除しない
  if ($file -match "App") {
    continue
  }
  $result = git rm --cached "$file" 2>&1
  $resultString = $result | Out-String
  if ($resultString -notmatch "fatal") {
    $removedFiles += $file
    "Removed: $file" | Out-File -FilePath $logPath -Append
    echo "Removed: $file"
  }
  else {
    "Error:  $file" | Out-File -FilePath $logPath -Append
    "        $resultString" | Out-File -FilePath $logPath -Append
    echo "Error: $file"
    echo "       $resultString"
  }
}

# 削除されたファイルがある場合のみコミットとファイルの出力を行う
if ($removedFiles.Count -gt 0) {
  # 変更をコミット
  git commit -m "Remove ignored files"

  # ユーザーのDownloadsフォルダのパスを取得
  $outputFolder = $shellapp.Namespace("shell:Downloads").Self.Path

  # 削除されたファイルのリストをファイルに出力
  $outputPath = Join-Path $outputFolder ("RemovedFiles_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")
  $removedFiles | Out-File -FilePath $outputPath

  # 出力されたファイルのパスを表示
  echo "削除されたファイルのリストはこちらに保存されました: $outputPath"

  # ファイルを開く
  Invoke-Item $outputPath
}
else {
  echo "削除するファイルはありませんでした。" | Out-File -FilePath $logPath -Append
}

# ログファイルのパスを表示
echo "ログファイルはこちらに保存されました: $logPath"