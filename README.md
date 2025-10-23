# BL4 Serial Toolkit (React + Element UI + FastAPI)

A toolkit for decoding, analyzing, and generating Borderlands 4 item serials.  
Frontend: React (Vite) + Element React components.  
Backend: Python FastAPI for ingestion, analysis, and decoding.

This repo ships a full starter app — frontend + backend plus example data and step-by-step setup.

See the "QUICKSTART" section below to run the app locally.

LEGAL: For research / educational use only. Do not use to cheat in multiplayer or violate game terms.

License: This project is licensed under the Prosperity Public License 3.0.0 — you may use, copy, and modify it for noncommercial purposes only.

---

## QUICKSTART — Windows 11 (download & run bootstrap.ps1 — first time)

### Prerequisites — install if missing

- Git: https://git-scm.com/  
- Python 3.10+ (Add Python to PATH during install): https://www.python.org/downloads/  
- Node.js 18+ (LTS): https://nodejs.org/  
- Optional: VS Code (nice, but not required)

### Download bootstrap.ps1 (example commands)

Open Windows PowerShell (normal user), change to the folder where you want the repo (e.g., Desktop) and download the script:

```powershell
cd $HOME\Desktop
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Unitech357/BL4_Serial_Toolkit/main/bootstrap.ps1" -OutFile .\bootstrap.ps1
```

### Inspect the script (recommended)

```powershell
notepad .\bootstrap.ps1
# or
Get-Content .\bootstrap.ps1 | more
```
Confirm it points to `https://github.com/Unitech357/BL4_Serial_Toolkit.git` (default) or your fork.

### Run the script (one-time temporary bypass — recommended)

One-liner (no permanent policy change):

```powershell
powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1 -Start
```

What this does:

- Clones `https://github.com/Unitech357/BL4_Serial_Toolkit.git` (or pulls if folder exists)  
- Creates `backend/.venv` and installs pip packages from `backend/requirements.txt`  
- Runs `npm install` (or `npm ci`) in `frontend/`  
- Starts backend (uvicorn) and frontend (Vite) in two new PowerShell windows

### Alternatively set execution policy (optional)

If you prefer to allow running local scripts without bypass each time:

1. Run PowerShell as Administrator once:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

2. Then run:

```powershell
.\bootstrap.ps1 -Start
```

### After the script completes successfully

- Backend API docs: http://127.0.0.1:8000/docs  
- Frontend UI: http://localhost:3000  
- Cache files created on first import / after upload:
  - `backend/cache/rows.jsonl`  
  - `backend/cache/maps.json`

### Where things are created

- Repo folder created (or updated) by the script, e.g. `BL4_Serial_Toolkit/` in the folder where you ran `bootstrap.ps1`.  
- `backend/.venv` — Python virtual environment  
- `frontend/node_modules` — Node deps (not committed to git)  
- `backend/cache` — runtime cache; created when you run import

### If you run the Bash script instead (`bootstrap.sh`)

- Place it in the same location (repo root) if you want it versioned in the repo. Useful for WSL/Git Bash/macOS/Linux.
- Usage (WSL / Git Bash / macOS / Linux):

```bash
chmod +x bootstrap.sh
./bootstrap.sh
# to also start servers:
./bootstrap.sh "" main start
```

It behaves similarly: clones repo, creates venv, installs pip packages, installs Node deps.

---

## Common errors & quick fixes

- “git not found”  
  Install Git and reopen PowerShell: https://git-scm.com/

- “Python not found”  
  Install Python 3.10+ and ensure “Add Python to PATH” is checked: https://www.python.org/downloads/

- “Node not found”  
  Install Node 18+ and ensure Node is in PATH: https://nodejs.org/

- `pip install` errors (compilation/build issues)  
  - Activate venv manually and run `pip install -r requirements.txt` to see full error.  
  - On Windows, some packages require Visual C++ Build Tools: https://visualstudio.microsoft.com/visual-cpp-build-tools/

- `npm install` fails  
  - Delete `node_modules` and retry. Check `npm-debug.log` for details.

- “Port already in use”  
  - Another process is using port `8000` or `3000`. Use Task Manager / `netstat -ano` to identify and stop the process, or change ports for Uvicorn / Vite.

---

## Stopping and restarting servers

- If you used `-Start`, two new PowerShell windows were opened for backend and frontend — close them to stop the servers.  
- To run manually:
  - Backend:

```powershell
cd <repo>\backend
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

  - Frontend (new terminal):

```powershell
cd <repo>\frontend
npm run dev
```

---

## Security note
Inspect any script you download before running it. Running with `ExecutionPolicy Bypass` is fine for a one-off run of a known script you inspected, but avoid blindly executing unknown scripts.

---

## Optional additions you might want
- Auto-upload sample CSV after bootstrap finishes (opt-in) — script can POST `examples/sample_small.csv` to `/api/import`.  
- Single installer (.exe) or PowerShell click-once packaging — can be provided on request.  
- Add more robust logging or allow changing default ports via script parameters.

---

If you want, I can:
- Add the optional auto-upload sample CSV step to `bootstrap.ps1` and commit it to your repo (opt‑in).  
- Update `bootstrap.sh` in the repo root as well (I’ve already provided the updated script text).  
- Provide a short README snippet with a one-line curl/PowerShell command to seed the cache after running bootstrap.
