param (
  [string]$directoryPath
)

# �w�肳�ꂽ�f�B���N�g���Ɉړ�
cd $directoryPath

# .gitignore�ɋL�q����Ă��邪�ǐՂ���Ă���t�@�C����������
$ignoredFiles = git ls-files -o --ignored --exclude-standard

# �폜���ꂽ�t�@�C���̃��X�g��ۑ����邽�߂̕ϐ�
$removedFiles = @()

# �����̃t�@�C�����L���b�V������폜
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

# �폜���ꂽ�t�@�C��������ꍇ�̂݃R�~�b�g�ƃt�@�C���̏o�͂��s��
if ($removedFiles.Count -gt 0) {
  # �ύX���R�~�b�g
  git commit -m "Remove ignored files"

  # ���[�U�[��Downloads�t�H���_�̃p�X���擾
  $shellapp = New-Object -ComObject Shell.Application
  $outputFolder = $shellapp.Namespace("shell:Downloads").Self.Path

  # �폜���ꂽ�t�@�C���̃��X�g���t�@�C���ɏo��
  $outputPath = Join-Path $outputFolder ("RemovedFiles_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")
  $removedFiles | Out-File -FilePath $outputPath

  # �o�͂��ꂽ�t�@�C���̃p�X��\��
  echo "�폜���ꂽ�t�@�C���̃��X�g�͂�����ɕۑ�����܂���: $outputPath"

  # �t�@�C�����J��
  Invoke-Item $outputPath
}
else {
  echo "�폜����t�@�C���͂���܂���ł����B"
}
