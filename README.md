# BL4 Serial Toolkit (React + Element UI + FastAPI)

A toolkit for decoding, analyzing, and generating Borderlands 4 item serials.  
Frontend: React (Vite) + Element React components.  
Backend: Python FastAPI for ingestion, analysis, and decoding.

This repo ships a full starter app — frontend + backend plus example data and step-by-step setup.

See the "QUICKSTART" section below to run the app locally.

LEGAL: For research/educational use only. Do not use to cheat in multiplayer or violate game terms.

## License
This project is licensed under the [Prosperity Public License 3.0.0](https://prosperitylicense.com/versions/3.0.0) — 
you may use, copy, and modify it for noncommercial purposes only.

Windows 11 — step-by-step: download and run bootstrap.ps1 (first time)

Prerequisites — install if missing

Git: https://git-scm.com/
Python 3.10+ (Add Python to PATH during install): https://www.python.org/downloads/
Node.js 18+ (LTS): https://nodejs.org/
Optional: VS Code (nice, but not required)

Download bootstrap.ps1 (example commands)

Open Windows PowerShell (normal user).
Change to the folder where you want the repo (e.g., Desktop):
cd $HOME\Desktop
Download the script from your repo:
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Unitech357/BL4_Serial_Toolkit/main/bootstrap.ps1" -OutFile .\bootstrap.ps1

Inspect the script (recommended)

Open it in Notepad: notepad .\bootstrap.ps1
Confirm it points to your repo (the default in the script is your repo).

Run the script (one-time temporary bypass — recommended)

One-liner: downloads and runs with bypassed execution policy for this invocation (no permanent policy change):
powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1 -Start
What this does:
Clones https://github.com/Unitech357/BL4_Serial_Toolkit.git (or pulls if folder exists)
Creates backend/.venv, installs pip packages from backend/requirements.txt
Runs npm install (or npm ci) in frontend/
Starts backend (uvicorn) and frontend (Vite) in two new PowerShell windows

Alternatively set execution policy (optional)

If you prefer to allow running local scripts without bypass each time:
Run PowerShell as Administrator once:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Then run:
.\bootstrap.ps1 -Start

After the script completes successfully

Backend API docs: http://127.0.0.1:8000/docs
Frontend UI: http://localhost:3000
Cache files created on first import / after upload:
backend/cache/rows.jsonl
backend/cache/maps.json

Where things are created

Repo folder created (or updated) by the script, e.g. BL4_Serial_Toolkit/ in the folder where you ran bootstrap.ps1.
backend/.venv — Python virtual environment
frontend/node_modules — Node deps (not committed to git)
backend/cache — runtime cache; created when you run import

If you run the Bash script instead (bootstrap.sh)

Place it in the same location (repo root) if you want it versioned in the repo.
Usage on WSL / Git Bash / macOS / Linux:
chmod +x bootstrap.sh
./bootstrap.sh
Pass a third arg to start servers, e.g. ./bootstrap.sh "" main start
It behaves similarly: clones repo, creates venv, installs pip packages, installs Node deps.

Common errors & quick fixes

“git not found”
Install Git and reopen PowerShell.
“Python not found”
Install Python 3.10+, ensure “Add Python to PATH” is checked.
“Node not found”
Install Node 18+, ensure Node in PATH.
pip install errors (compilation/build issues)
Activate venv manually and try pip install -r requirements.txt to see full error.
On Windows, some packages require Visual C++ Build Tools. Install from: https://visualstudio.microsoft.com/visual-cpp-build-tools/
npm install fails
Delete node_modules and retry. Check npm logs in npm-debug.log.
“Port already in use”
Another process is using 8000 or 3000. Use netstat/lsof or change ports in uvicorn / Vite.
To stop Uvicorn or Vite processes started by the script, close the PowerShell windows created by -Start, or kill the PIDs.

Stopping and restarting servers

If you used -Start, two new PowerShell windows were opened for backend and frontend — close them to stop the servers.
To run manually:
Backend:
cd /backend
..venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
Frontend (new terminal):
cd /frontend
npm run dev

Security note

Inspect any script you download before running it. Running with ExecutionPolicy Bypass is safe for one-off known scripts you inspected, but avoid blindly executing unknown scripts.

Optional additions you might want

Auto-upload sample CSV after bootstrap finishes (I can add an opt-in step to the script that posts examples/sample_small.csv to /api/import).
Make a single installer .exe or PowerShell click-once — I can provide that if needed.
Add more robust logging or allow changing default ports via parameters.
