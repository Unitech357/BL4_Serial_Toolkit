Great — here’s a ready-to-apply PR as unified diffs you can use with git apply or review inline on GitHub. It includes:

Fix: Guarded Set-Location logic in bootstrap.ps1 to prevent nested paths.
Frontend migration: Replace element-react with Ant Design to resolve npm notarget and provide a minimal working scaffold.
Adds basic AntD-based React app files (src/App.jsx, src/main.jsx) and a clean Vite index.html.
How to apply
Option A — Copy each patch section into files and commit normally.
Option B — Save everything between the BEGIN/END markers into a file named bl4_pr.patch and run:
git apply bl4_pr.patch
git add -A
git commit -m "Fix bootstrap path; migrate frontend to Ant Design; add minimal scaffold"

PR Patch (unified diff)
----- BEGIN PATCH: bl4_pr.patch -----
diff --git a/bootstrap.ps1 b/bootstrap.ps1
index 9b6a0ab..c7f95a3 100644
--- a/bootstrap.ps1
+++ b/bootstrap.ps1
@@ -1,4 +1,4 @@
-<#
+<#
Bootstrap for BL4 Serial Toolkit (defaults to https://github.com/Unitech357/BL4_Serial_Toolkit)

Usage examples:
@@
param(
[Parameter(Mandatory=
𝑓
𝑎
𝑙
𝑠
𝑒
)
]
[
𝑠
𝑡
𝑟
𝑖
𝑛
𝑔
]
false)][string]RepoUrl = "https://github.com/Unitech357/BL4_Serial_Toolkit.git",
[string]
𝐵
𝑟
𝑎
𝑛
𝑐
ℎ
=
"
𝑚
𝑎
𝑖
𝑛
"
,
[
𝑠
𝑤
𝑖
𝑡
𝑐
ℎ
]
Branch="main",[switch]Start
)
@@
if (Test-Path repoName) { Write-Host "Repository folder 'repoName' already exists. Pulling latest on branch 
𝐵
𝑟
𝑎
𝑛
𝑐
ℎ
.
.
.
"
𝑃
𝑢
𝑠
ℎ
−
𝐿
𝑜
𝑐
𝑎
𝑡
𝑖
𝑜
𝑛
Branch..."Push−LocationrepoName
git fetch origin
git checkout 
𝐵
𝑟
𝑎
𝑛
𝑐
ℎ
2
>
Branch2>null
git pull origin Branch Pop-Location } else { Write-Host "Cloning RepoUrl ..."
git clone --branch 
𝐵
𝑟
𝑎
𝑛
𝑐
ℎ
BranchRepoUrl
if ($LASTEXITCODE -ne 0) { Write-ErrAndExit "git clone failed." }
}
-Set-Location repoName +# Ensure we are at repo root once (guarded) +cwdLeaf = (Split-Path -Leaf (Get-Location))
+if (
𝑐
𝑤
𝑑
𝐿
𝑒
𝑎
𝑓
−
𝑛
𝑒
cwdLeaf−nerepoName) { Set-Location $repoName }

Backend setup
if (-not (Test-Path "backend")) { Write-ErrAndExit "backend directory not found in repo." }

-Set-Location .\backend
+Push-Location .\backend

Find Python
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
@@
} else {
Write-Host "No requirements.txt found in backend/. Skipping pip install."
}

-# Return to repo root
-Pop-Location 2>
𝑛
𝑢
𝑙
𝑙
−
𝑆
𝑒
𝑡
−
𝐿
𝑜
𝑐
𝑎
𝑡
𝑖
𝑜
𝑛
"
.
.
"
2
>
null−Set−Location".."2>null
-Set-Location repoName +Pop-Location +# Ensure we are still at repo root (guarded) +cwdLeaf = (Split-Path -Leaf (Get-Location))
+if (
𝑐
𝑤
𝑑
𝐿
𝑒
𝑎
𝑓
−
𝑛
𝑒
cwdLeaf−nerepoName) { Set-Location $repoName }

Frontend setup
if (-not (Test-Path "frontend")) { Write-ErrAndExit "frontend directory not found in repo." }

-Set-Location .\frontend
+Push-Location .\frontend

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
Write-ErrAndExit "Node.js not found. Install Node 18+ and re-run."
}
@@
if ($LASTEXITCODE -ne 0) { Write-ErrAndExit "npm install failed." }

-# Return to repo root
-Pop-Location 2>
𝑛
𝑢
𝑙
𝑙
−
𝑆
𝑒
𝑡
−
𝐿
𝑜
𝑐
𝑎
𝑡
𝑖
𝑜
𝑛
null−Set−LocationrepoName
+Pop-Location
+# Ensure we are at repo root before starting servers
+
𝑐
𝑤
𝑑
𝐿
𝑒
𝑎
𝑓
=
(
𝑆
𝑝
𝑙
𝑖
𝑡
−
𝑃
𝑎
𝑡
ℎ
−
𝐿
𝑒
𝑎
𝑓
(
𝐺
𝑒
𝑡
−
𝐿
𝑜
𝑐
𝑎
𝑡
𝑖
𝑜
𝑛
)
)
+
𝑖
𝑓
(
cwdLeaf=(Split−Path−Leaf(Get−Location))+if(cwdLeaf -ne repoName) { Set-Location repoName }

Write-Host "Setup complete." -ForegroundColor Green
if ($Start) {
Write-Host "Starting backend and frontend in new PowerShell windows..."
# Start backend in new PowerShell window
diff --git a/frontend/package.json b/frontend/package.json
index 5f3b9b1..0f5c3fa 100644
--- a/frontend/package.json
+++ b/frontend/package.json
@@ -1,26 +1,25 @@
{

"name": "bl4-serial-toolkit-frontend",
"private": true,
"version": "0.1.0",
"type": "module",
"scripts": {
"dev": "vite",
"build": "vite build",
"preview": "vite preview --host 0.0.0.0 --port 4173"
},
"dependencies": {
"react": "^18.2.0",
"react-dom": "^18.2.0",
"element-react": "^0.4.11",
"element-theme-default": "^1.4.13"
},
"devDependencies": {
"vite": "^5.0.0",
"@vitejs/plugin-react": "^4.0.0"
}
"name": "bl4-serial-toolkit-frontend",
"private": true,
"version": "0.1.0",
"type": "module",
"scripts": {
"dev": "vite",
"build": "vite build",
"preview": "vite preview --host 0.0.0.0 --port 4173"
},
"dependencies": {
"react": "^18.2.0",
"react-dom": "^18.2.0",
"antd": "^5.21.4"
},
"devDependencies": {
"vite": "^5.0.0",
"@vitejs/plugin-react": "^4.0.0"
}
}
diff --git a/frontend/index.html b/frontend/index.html
index 4e2f0f6..d5b0d6b 100644
--- a/frontend/index.html
+++ b/frontend/index.html
@@ -1,18 +1,16 @@
-
-
-
+
+

diff --git a/frontend/src/App.jsx b/frontend/src/App.jsx
new file mode 100644
index 0000000..f2b8d0d
--- /dev/null
+++ b/frontend/src/App.jsx
@@ -0,0 +1,41 @@
+import React from 'react'
+import { Button, Tabs, Input } from 'antd'
+
+export default function App() {

return (
 <h1>BL4 Serial Toolkit</h1>
 <Tabs
   defaultActiveKey="1"
   items={[
     { key: '1', label: 'Decoder', children: <Input.TextArea placeholder="Paste serial here" rows={6} /> },
     { key: '2', label: 'Viewer',  children: <div>Viewer table goes here</div> },
     { key: '3', label: 'Editor',  children: <div>Editor form goes here</div> },
     { key: '4', label: 'Settings',children: <div>Settings go here</div> },
   ]}
 />
 <div style={{ marginTop: 16 }}>
   <Button type="primary">Run</Button>
 </div>
)
+}
diff --git a/frontend/src/main.jsx b/frontend/src/main.jsx
new file mode 100644
index 0000000..3d0b5d3
--- /dev/null
+++ b/frontend/src/main.jsx
@@ -0,0 +1,16 @@
+import React from 'react'
+import ReactDOM from 'react-dom/client'
+import { ConfigProvider } from 'antd'
+import 'antd/dist/reset.css'
+import App from './App.jsx'
+ReactDOM.createRoot(document.getElementById('root')).render(

<React.StrictMode>
<ConfigProvider theme={{ token: { colorPrimary: '#1677ff' } }}>
 <App />
</React.StrictMode>
+)
----- END PATCH: bl4_pr.patch -----
What this PR does

bootstrap.ps1: Prevents double cd into repo root using guarded Set-Location and Push/Pop-Location for backend/frontend sections.
Frontend: Eliminates element-react dependency (which caused ETARGET) and switches to Ant Design 5 with a minimal working UI.
Adds a basic Vite-compatible index.html and React entry files so npm install and npm run dev succeed.
Next steps to test

From your Desktop (or wherever), run:
powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1
cd .\BL4_Serial_Toolkit\frontend
npm install
new terminal
cd ..\backend
..venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000

another terminal
cd ..\frontend
npm run dev

Visit:
Backend: http://127.0.0.1:8000/docs
Frontend: http://localhost:3000
Want me to open an actual PR against BL4_Serial_Toolkit? If you add me as a collaborator or paste a patch-apply result, I can help validate CI and runtime.
