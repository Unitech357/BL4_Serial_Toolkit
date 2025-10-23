#!/usr/bin/env bash
set -euo pipefail

# Default repository (your live repo)
REPO_URL="${1:-https://github.com/Unitech357/BL4_Serial_Toolkit.git}"
BRANCH="${2:-main}"
START_SERVERS=${3:-""}  # pass any value to start servers automatically

function err() {
  echo "ERROR: $1" >&2
  exit 1
}

# Check git
if ! command -v git >/dev/null 2>&1; then
  err "git not found. Install git and re-run."
fi

# derive repo name
repoName="$(basename -s .git "$REPO_URL")"

if [ -d "$repoName" ]; then
  echo "Directory $repoName exists. Pulling latest on branch $BRANCH..."
  pushd "$repoName" >/dev/null
  git fetch origin
  git checkout "$BRANCH" || true
  git pull origin "$BRANCH" || true
  popd >/dev/null
else
  echo "Cloning $REPO_URL ..."
  git clone --branch "$BRANCH" "$REPO_URL" || err "git clone failed."
fi

cd "$repoName" || err "cd failed"

# Backend
[ -d backend ] || err "backend directory missing in repo."

cd backend

# Check python
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  err "Python not found. Install Python 3.10+ and re-run."
fi

# Create venv if missing
if [ ! -d ".venv" ]; then
  echo "Creating virtualenv..."
  $PY -m venv .venv || err "Failed to create venv"
else
  echo "Virtualenv exists, skipping creation."
fi

# Activate venv in this shell
# shellcheck disable=SC1091
source .venv/bin/activate

echo "Upgrading pip..."
python -m pip install --upgrade pip setuptools wheel

if [ -f requirements.txt ]; then
  echo "Installing Python requirements..."
  pip install -r requirements.txt || err "pip install failed"
else
  echo "No backend/requirements.txt found, skipping pip install."
fi

deactivate || true
cd ..

# Frontend
[ -d frontend ] || err "frontend directory missing in repo."

cd frontend

if ! command -v node >/dev/null 2>&1; then
  err "Node.js not found. Install Node 18+ and re-run."
fi

# prefer npm ci if lockfile present
if [ -f package-lock.json ]; then
  echo "Running npm ci..."
  npm ci || err "npm ci failed"
else
  echo "Running npm install..."
  npm install || err "npm install failed"
fi

cd ..

echo "Setup complete."

if [ -n "$START_SERVERS" ]; then
  echo "Starting backend and frontend in background..."
  # Start backend with venv
  (cd backend && source .venv/bin/activate && uvicorn app.main:app --reload --host 127.0.0.1 --port 8000) &
  BACK_PID=$!
  # Start frontend
  (cd frontend && npm run dev -- --host 0.0.0.0 --port 3000) &
  FRONT_PID=$!
  echo "Backend PID: $BACK_PID"
  echo "Frontend PID: $FRONT_PID"
  echo "Backend: http://127.0.0.1:8000"
  echo "Frontend: http://localhost:3000"
  echo "To stop these, run: kill $BACK_PID $FRONT_PID"
else
  echo "To start servers manually:"
  echo "  Backend:"
  echo "    cd $repoName/backend"
  echo "    source .venv/bin/activate"
  echo "    uvicorn app.main:app --reload --host 127.0.0.1 --port 8000"
  echo "  Frontend (new terminal):"
  echo "    cd $repoName/frontend"
  echo "    npm run dev"
fi
