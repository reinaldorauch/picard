function ThrowOnExeError {
  param( [String]$Message )
  If ($LASTEXITCODE -ne 0) {
    Throw $Message
  }
}

# Build
Remove-Item -Path build,dist/picard,locale -Recurse -ErrorAction Ignore
python setup.py clean 2>&1 | %{ "$_" }
ThrowOnExeError "setup.py clean failed"
python setup.py build 2>&1 | %{ "$_" }
ThrowOnExeError "setup.py build failed"
python setup.py build_ext -i 2>&1 | %{ "$_" }
ThrowOnExeError "setup.py build_ext -i failed"

# Package application
pyinstaller --noconfirm --clean picard.spec 2>&1 | %{ "$_" }
ThrowOnExeError "PyInstaller failed"

# Workaround for https://github.com/pyinstaller/pyinstaller/issues/4429
If (Test-Path dist\picard\PyQt5\translations -PathType Container) {
  Move-Item -Path dist\picard\PyQt5\translations -Destination dist\picard\PyQt5\Qt
}

# Delete unused files
Remove-Item -Path dist\picard\libcrypto-1_1.dll
Remove-Item -Path dist\picard\libssl-1_1.dll

# Build the installer
makensis.exe /INPUTCHARSET UTF8 installer\picard-setup.nsi 2>&1 | %{ "$_" }
ThrowOnExeError "NSIS failed"
