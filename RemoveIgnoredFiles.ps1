param (
  [string]$directoryPath
)

# ���O�t�@�C���̃p�X��ݒ�
$shellapp = New-Object -ComObject Shell.Application
$logFolder = $shellapp.Namespace("shell:Downloads").Self.Path

# ���{��̃t�H���_���ŐV�����t�H���_���쐬
$cleanupFolderName = "Git�N���[���A�b�v_" + (Get-Date -Format "yyyyMMdd_HHmmss")
$cleanupFolderPath = Join-Path $logFolder $cleanupFolderName
New-Item -ItemType Directory -Path $cleanupFolderPath -Force

$logPath = Join-Path $cleanupFolderPath "Git�N���[���A�b�v���O.txt"

# �w�肳�ꂽ�f�B���N�g���Ɉړ�
cd $directoryPath

# ���|�W�g�����̑S�ǐՃt�@�C�����擾���A�t�@�C���ɏo��
$trackedFiles = git ls-files --cached
$trackedFilesPath = Join-Path $cleanupFolderPath "�ǐՂ���Ă���t�@�C���̃��X�g.txt"
$trackedFiles | Out-File -FilePath $trackedFilesPath
echo "�ǐՂ���Ă���t�@�C���̃��X�g�͂�����ɕۑ�����܂���: $trackedFilesPath" | Out-File -FilePath $logPath -Append

# .gitignore�Ŗ��������ׂ��t�@�C������肵�A�t�@�C���ɏo��
$ignoredFiles = git ls-files --others --ignored --exclude-standard
$ignoredFilesPath = Join-Path $cleanupFolderPath "���������ׂ��t�@�C���̃��X�g.txt"
$ignoredFiles | Out-File -FilePath $ignoredFilesPath
echo "���������ׂ��t�@�C���̃��X�g�͂�����ɕۑ�����܂���: $ignoredFilesPath" | Out-File -FilePath $logPath -Append

# �폜���ꂽ�t�@�C���̃��X�g��ۑ����邽�߂̕ϐ�
$removedFiles = @()

# .gitignore�Ŏw�肳��Ă��邪�ǐՂ���Ă���t�@�C�������
$ignoredButTrackedFiles = git ls-files --cached --ignored --exclude-standard
$ignoredButTrackedFilesPath = Join-Path $cleanupFolderPath "���������ׂ����ǐՂ���Ă���t�@�C���̃��X�g.txt"
$ignoredButTrackedFiles | Out-File -FilePath $ignoredButTrackedFilesPath
echo "���������ׂ����ǐՂ���Ă���t�@�C���̃��X�g�͂�����ɕۑ�����܂���: $ignoredButTrackedFilesPath" | Out-File -FilePath $logPath -Append

# �����̃t�@�C�����L���b�V������폜
foreach ($file in $ignoredButTrackedFiles) {
  $result = git rm --cached "$file" 2>&1
  $resultString = $result | Out-String
  if ($resultString -notmatch "fatal") {
    $removedFiles += $file
    "Removed: $file" | Out-File -FilePath $logPath -Append
  }
  else {
    "Error:  $file" | Out-File -FilePath $logPath -Append
    "        $resultString" | Out-File -FilePath $logPath -Append
    echo "Error: $file"
    echo "       $resultString"
  }
}

# �폜���ꂽ�t�@�C��������ꍇ�̂݃R�~�b�g�ƃt�@�C���̏o�͂��s��
if ($removedFiles.Count -gt 0) {
  # �ύX���R�~�b�g
  echo "�R�~�b�g�O�̃f�o�b�O���" | Out-File -FilePath $logPath -Append
  git commit -m "�������ꂽ�t�@�C�����폜" 2>&1 | Out-File -FilePath $logPath -Append
  if (-not $?) {
    echo "�R�~�b�g�����Ɏ��s���܂����B" | Out-File -FilePath $logPath -Append
  }
  echo "�R�~�b�g��̃f�o�b�O���" | Out-File -FilePath $logPath -Append

  # �폜���ꂽ�t�@�C���̃��X�g���t�@�C���ɏo��
  $outputPath = Join-Path $cleanupFolderPath "�폜���ꂽ�t�@�C���̃��X�g.txt"
  $removedFiles | Out-File -FilePath $outputPath

  # �o�͂��ꂽ�t�@�C���̃p�X��\��
  echo "�폜���ꂽ�t�@�C���̃��X�g�͂�����ɕۑ�����܂���: $outputPath"

  # �t�@�C�����J��
  Invoke-Item $outputPath
}
else {
  echo "�폜����t�@�C���͂���܂���ł����B" | Out-File -FilePath $logPath -Append
}

# ���O�t�@�C���̃p�X��\��
echo "���O�t�@�C���͂�����ɕۑ�����܂���: $logPath"