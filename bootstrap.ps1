<#
Bootstrap for BL4 Serial Toolkit (defaults to https://github.com/Unitech357/BL4_Serial_Toolkit)

Usage examples:
  # Basic setup (clone/pip/npm)
  .\bootstrap.ps1

  # Setup and start backend + frontend in new windows
  .\bootstrap.ps1 -Start

  # Provide a different repo or branch if desired:
  .\bootstrap.ps1 -RepoUrl "https://github.com/you/yourrepo.git" -Branch "dev" -Start
#>

param(
    [Parameter(Mandatory=$false)][string]$RepoUrl = "https://github.com/Unitech357/BL4_Serial_Toolkit.git",
    [string]$Branch = "main",
    [switch]$Start
)

function Write-ErrAndExit($msg, $code=1) {
    Write-Host "ERROR: $msg" -ForegroundColor Red
    exit $code
}

# Ensure Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-ErrAndExit "git not found. Install Git and re-run."
}

# Derive repo name
$repoName = ($RepoUrl -split '/')[ -1 ]
if ($repoName.ToLower().EndsWith('.git')) { $repoName = $repoName.Substring(0, $repoName.Length - 4) }

# Clone or update
if (Test-Path $repoName) {
    Write-Host "Repository folder '$repoName' already exists. Pulling latest on branch $Branch..."
    Push-Location $repoName
    git fetch origin
    git checkout $Branch 2>$null
    git pull origin $Branch
    Pop-Location
} else {
    Write-Host "Cloning $RepoUrl ..."
    git clone --branch $Branch $RepoUrl
    if ($LASTEXITCODE -ne 0) { Write-ErrAndExit "git clone failed." }
}

Set-Location $repoName

# Backend setup
if (-not (Test-Path "backend")) { Write-ErrAndExit "backend directory not found in repo." }

Set-Location .\backend

# Find Python
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) { $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue }
if (-not $pythonCmd) { Write-ErrAndExit "Python not found in PATH. Install Python 3.10+ and re-run." }

# Create venv
if (-not (Test-Path ".venv")) {
    Write-Host "Creating Python virtual environment in backend/.venv ..."
    & $pythonCmd.Path -m venv .venv
    if ($LASTEXITCODE -ne 0) { Write-ErrAndExit "Failed to create virtualenv." }
} else {
    Write-Host "Virtual environment exists, skipping creation."
}

# Activate venv for this script
$activate = Join-Path (Get-Location) '.venv\Scripts\Activate.ps1'
if (-not (Test-Path $activate)) { Write-ErrAndExit "Activation script not found at $activate" }

Write-Host "Activating virtualenv..."
. $activate

Write-Host "Upgrading pip..."
python -m pip install --upgrade pip setuptools wheel

if (Test-Path "requirements.txt") {
    Write-Host "Installing Python requirements..."
    pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) { Write-ErrAndExit "pip install failed." }
} else {
    Write-Host "No requirements.txt found in backend/. Skipping pip install."
}

# Return to repo root
Pop-Location 2>$null
Set-Location ".." 2>$null
Set-Location $repoName

# Frontend setup
if (-not (Test-Path "frontend")) { Write-ErrAndExit "frontend directory not found in repo." }

Set-Location .\frontend

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-ErrAndExit "Node.js not found. Install Node 18+ and re-run."
}

# Prefer npm ci when lockfile exists
if (Test-Path "package-lock.json") {
    Write-Host "Installing Node dependencies with npm ci..."
    npm ci
} else {
    Write-Host "Installing Node dependencies with npm install..."
    npm install
}
if ($LASTEXITCODE -ne 0) { Write-ErrAndExit "npm install failed." }

# Return to repo root
Pop-Location 2>$null
Set-Location $repoName

Write-Host "Setup complete." -ForegroundColor Green
if ($Start) {
    Write-Host "Starting backend and frontend in new PowerShell windows..."
    # Start backend in new PowerShell window
    $backendCommand = "cd `"$PWD\backend`"; .\.venv\Scripts\Activate.ps1; uvicorn app.main:app --reload --host 127.0.0.1 --port 8000"
    Start-Process -FilePath "powershell" -ArgumentList "-NoExit","-Command",$backendCommand

    # Start frontend in new PowerShell window
    $frontendCommand = "cd `"$PWD\frontend`"; npm run dev"
    Start-Process -FilePath "powershell" -ArgumentList "-NoExit","-Command",$frontendCommand

    Write-Host "Backend (uvicorn) should be at http://127.0.0.1:8000"
    Write-Host "Frontend (Vite) should be at http://localhost:3000"
} else {
    Write-Host ""
    Write-Host "To start servers manually:"
    Write-Host "  Backend:"
    Write-Host "    cd $repoName/backend"
    Write-Host "    .\\.venv\\Scripts\\Activate.ps1"
    Write-Host "    uvicorn app.main:app --reload --host 127.0.0.1 --port 8000"
    Write-Host "  Frontend (new terminal):"
    Write-Host "    cd $repoName/frontend"
    Write-Host "    npm run dev"
}
