$ErrorActionPreference = "Stop"

$appRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$pythonPath = $null
$launcher = Get-Command py -ErrorAction SilentlyContinue

if ($launcher) {
    foreach ($version in @("3.13", "3.12", "3.11")) {
        $candidate = & $launcher.Source "-$version" -c "import sys; print(sys.executable)" 2>$null
        if ($LASTEXITCODE -eq 0 -and $candidate) {
            $pythonPath = ([string]$candidate).Trim()
            break
        }
    }
}

if (-not $pythonPath) {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) {
        $candidate = & $python.Source -c "import sys; print(sys.executable)" 2>$null
        if ($LASTEXITCODE -eq 0 -and $candidate) {
            $candidatePath = ([string]$candidate).Trim()
            $versionText = & $candidatePath -c "import sys; print(str(sys.version_info.major)+'.'+str(sys.version_info.minor))" 2>$null
            if ($versionText -match "^3\.(11|12|13)$") { $pythonPath = $candidatePath }
        }
    }
}

if (-not $pythonPath) {
    throw "Install Python 3.11, 3.12, or 3.13 from python.org, then run Install Bhai.bat again."
}

$pythonVersion = & $pythonPath -c "import sys; print(str(sys.version_info.major)+'.'+str(sys.version_info.minor))"
Write-Host "Using Python $pythonVersion"
Write-Host "Setting up Bhai in $appRoot"

$venvPython = Join-Path $appRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    & $pythonPath -m venv (Join-Path $appRoot ".venv")
    if ($LASTEXITCODE -ne 0) { throw "Could not create Bhai's Python environment." }
}

Write-Host "Installing Bhai and its browser support. This downloads the app's required packages."
Push-Location $appRoot
try {
    & $venvPython "setup.py"
    if ($LASTEXITCODE -ne 0) { throw "Dependency installation failed." }
}
finally {
    Pop-Location
}

$pythonw = Join-Path (Split-Path -Parent $venvPython) "pythonw.exe"
if (-not (Test-Path $pythonw)) { $pythonw = $venvPython }
$desktop = [Environment]::GetFolderPath("Desktop")
if (-not $desktop) { $desktop = Join-Path $env:USERPROFILE "Desktop" }
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut((Join-Path $desktop "Bhai.lnk"))
$shortcut.TargetPath = $pythonw
$shortcut.Arguments = '"' + (Join-Path $appRoot "main.py") + '"'
$shortcut.WorkingDirectory = $appRoot
$shortcut.IconLocation = (Join-Path $appRoot "config\bhai.ico") + ",0"
$shortcut.Description = "Bhai personal AI assistant"
$shortcut.Save()

Write-Host ""
Write-Host "Bhai is installed. A Bhai shortcut is on your desktop."
Write-Host "The app will ask for its model API key the first time it opens."
Start-Process -FilePath $pythonw -ArgumentList ('"' + (Join-Path $appRoot "main.py") + '"') -WorkingDirectory $appRoot
Read-Host "Press Enter to close this setup window"
