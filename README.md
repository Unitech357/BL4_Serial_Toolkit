
# BL4 Serial Toolkit (React + Ant Design + FastAPI)

A toolkit for decoding, analyzing, and generating Borderlands 4 item serials.

- Frontend: React (Vite) + Ant Design UI components
- Backend: Python FastAPI for ingestion, analysis, and decoding

LEGAL: For research/educational use only. Do not use to cheat in multiplayer or violate game terms.

License: Prosperity Public License 3.0.0 — noncommercial use permitted.

---

## What’s New

- Migrated UI library from Element React to Ant Design (antd) to fix npm install errors and use a maintained component set.
- Fixed bootstrap script path issue: `bootstrap.ps1` now guards `Set-Location` and uses `Push-Location`/`Pop-Location` to avoid nested paths like `BL4_Serial_Toolkit/BL4_Serial_Toolkit`.

---

## Repository Structure

```
BL4_Serial_Toolkit/
├─ backend/
│  ├─ app/
│  ├─ cache/              # Created after first import
│  ├─ .venv/              # Python virtual environment (created by bootstrap)
│  └─ requirements.txt
├─ frontend/
│  ├─ index.html
│  └─ src/
│     ├─ main.jsx
│     └─ App.jsx
├─ examples/
├─ bootstrap.ps1          # Windows PowerShell bootstrap
├─ bootstrap.sh           # Bash bootstrap (macOS/Linux/WSL)
└─ README.md
```

---

## QUICKSTART — Windows 11 (download & run bootstrap.ps1 — first time)

### Prerequisites — install if missing

- Git: https://git-scm.com/
- Python 3.10+ (Add Python to PATH during install): https://www.python.org/downloads/
- Node.js 18+ (LTS): https://nodejs.org/
- Optional: VS Code (recommended): https://code.visualstudio.com/

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
- Starts backend (Uvicorn) and frontend (Vite) in two new PowerShell windows

### Alternatively set execution policy (optional)

If you prefer to allow running local scripts without bypass each time:

Run PowerShell as Administrator once:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then run:

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

---

## QUICKSTART — macOS/Linux/WSL (optional, for contributors)

Use the Bash bootstrap. Not required on native Windows.

```bash
# from a folder where you want the repo cloned
curl -fsSL https://raw.githubusercontent.com/Unitech357/BL4_Serial_Toolkit/main/bootstrap.sh -o bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
# to also start servers automatically:
./bootstrap.sh "" main start
```

---

## Frontend (Ant Design)

The frontend uses Ant Design (antd).

- Installed via `npm install` as part of the bootstrap script
- Ant Design CSS reset is imported in `src/main.jsx`:

```jsx
import 'antd/dist/reset.css'
```

Minimal scaffold ships with:

- `frontend/src/main.jsx` — wraps the app with `ConfigProvider`
- `frontend/src/App.jsx` — simple layout using Tabs, Input, and Button components

Documentation: https://ant.design/components/overview/

---

## Running the servers manually

If you did not use `-Start` or want to run in existing terminals.

Backend:

```powershell
cd <repo>\backend
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

Frontend (new terminal):

```powershell
cd <repo>\frontend
npm run dev
```

---

## Importing example data (optional)

Seed the backend cache with a sample CSV after the servers are running.

PowerShell:

```powershell
# From repo root
$FilePath = Join-Path (Get-Location) "examples\sample_small.csv"
$uri = "http://127.0.0.1:8000/api/import"
$Form = @{ file = Get-Item $FilePath }
Invoke-RestMethod -Uri $uri -Method Post -Form $Form
```

curl:

```bash
curl -F "file=@examples/sample_small.csv" http://127.0.0.1:8000/api/import
```

After import, check backend/cache:
- `backend/cache/rows.jsonl`
- `backend/cache/maps.json`

---

## Troubleshooting

- “git not found”  
  Install Git and reopen your terminal: https://git-scm.com/

- “Python not found”  
  Install Python 3.10+ and ensure “Add Python to PATH” is checked: https://www.python.org/downloads/

- “Node not found”  
  Install Node 18+ and ensure Node is in PATH: https://nodejs.org/

- `pip install` errors (compilation/build issues)  
  - Activate venv and run `pip install -r requirements.txt` to see full error.  
  - On Windows, some packages require Visual C++ Build Tools: https://visualstudio.microsoft.com/visual-cpp-build-tools/

- `npm install` fails  
  - Delete `frontend/node_modules` and retry.  
  - Check logs in `%LOCALAPPDATA%\npm-cache\_logs\`.

- “Port already in use”  
  - Another process is using `8000` or `3000`. Use Task Manager / `netstat -ano` to identify and stop the process, or change ports for Uvicorn / Vite.

- Startup windows closed immediately  
  - If you ran with `-Start`, two new PowerShell windows are opened. Check their output. You can also start servers manually (see above) to keep them attached to your console.

---

## Notes on the bootstrap.ps1 fix

We fixed a path issue where the script could attempt to `Set-Location` into the repo folder multiple times, causing an invalid nested path like `BL4_Serial_Toolkit/BL4_Serial_Toolkit`. The updated script:

- Uses a guarded `Set-Location` so it only changes directory if not already in the repo root.
- Uses `Push-Location` / `Pop-Location` around `backend/` and `frontend/` setup to return safely to the repo root.

No user action is required beyond pulling the latest script.

---

## Security note

Inspect any script you download before running it. Running with `ExecutionPolicy Bypass` is fine for a one-off run of a known script you inspected, but avoid blindly executing unknown scripts.

---

## Credits & License

- UI: Ant Design (MIT)
- Backend: FastAPI (MIT)
- This repository: Prosperity Public License 3.0.0 (noncommercial). See LICENSE for details.
