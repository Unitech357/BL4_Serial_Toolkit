# BL4 Serial Toolkit (React + Ant Design + FastAPI)

A toolkit for decoding, analyzing, and generating Borderlands 4 item serials.  
Frontend: React (Vite) + Ant Design UI components.  
Backend: Python FastAPI for ingestion, analysis, and decoding.

This repo ships a full starter app — frontend + backend plus example data and step-by-step setup.

LEGAL: For research/educational use only. Do not use to cheat in multiplayer or violate game terms.

License: This project is licensed under the Prosperity Public License 3.0.0 — you may use, copy, and modify it for noncommercial purposes only.

---

## What’s New

- UI Library: Migrated from Element React to Ant Design (antd) to fix npm install errors and use a maintained component library.
- Bootstrap Script Fix: `bootstrap.ps1` now safely changes directories (guarded `Set-Location`) to prevent nested `BL4_Serial_Toolkit/BL4_Serial_Toolkit` path errors.

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
