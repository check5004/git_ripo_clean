param (
  [string]$directoryPath
)

# 指定されたディレクトリに移動
cd $directoryPath

# .gitignoreに記述されているが追跡されているファイルを見つける
$ignoredFiles = git ls-files -o --ignored --exclude-standard

# 削除されたファイルのリストを保存するための変数
$removedFiles = @()

# それらのファイルをキャッシュから削除
foreach ($file in $ignoredFiles) {
  $result = git rm --cached "$file" 2>&1
  $resultString = $result | Out-String
  if ($resultString -notmatch "fatal") {
    $removedFiles += $file
    echo "Removed: $file"
  }
  else {
    echo "Skip:  $file"
  }
}

# 削除されたファイルがある場合のみコミットとファイルの出力を行う
if ($removedFiles.Count -gt 0) {
  # 変更をコミット
  git commit -m "Remove ignored files"

  # ユーザーのDownloadsフォルダのパスを取得
  $shellapp = New-Object -ComObject Shell.Application
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
  echo "削除するファイルはありませんでした。"
}
