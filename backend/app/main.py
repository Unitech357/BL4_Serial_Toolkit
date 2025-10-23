from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import os, json, shutil
from pathlib import Path
from . import loader, analyzer, codec, storage, schemas

CFG = json.load(open(os.path.join(os.path.dirname(__file__), '..', 'config.json')))

app = FastAPI(title="BL4 Serial Toolkit API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)

# ensure cache dir
Path(CFG["cache_dir"]).mkdir(parents=True, exist_ok=True)

@app.post("/api/import")
async def api_import(file: UploadFile = File(...)):
    # save the uploaded CSV temporarily and run the loader
    try:
        tmp_path = os.path.join(CFG["cache_dir"], "upload_tmp.csv")
        with open(tmp_path, "wb") as f:
            shutil.copyfileobj(file.file, f)
        rows = loader.ingest_csv(tmp_path, chunksize=CFG["chunksize"])
        analyzer.run_analysis()
        maps = storage.load_maps()
        return {"ok": True, "rows": rows}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/maps")
def api_maps():
    return storage.load_maps()

@app.post("/api/decode")
def api_decode(payload: dict):
    s = payload.get("serial", "")
    if not s:
        raise HTTPException(status_code=400, detail="serial required")
    result = codec.decode(s)
    return result

@app.post("/api/bulk_decode")
def api_bulk(payload: dict):
    serials = payload.get("serials", [])
    out = []
    for s in serials:
        out.append(codec.decode(s))
    return {"decoded": out}

@app.post("/api/generate")
def api_generate(params: dict):
    # simple scaffold generator using maps
    maps = storage.load_maps()
    # use simple random combination of tokens found in maps (deterministic for now)
    import random
    candidates = []
    t = params.get('type') or ''
    m = params.get('manufacturer') or ''
    r = params.get('rarity') or ''
    for i in range(min(CFG.get('max_generate', 50), 20)):
        parts = []
        if m: parts.append(m)
        if t: parts.append(t)
        parts.append(''.join(random.choices('ABCDEFGHJKLMNPQRSTUVWXYZ23456789', k=6)))
        if r: parts.append(r)
        candidates.append('-'.join(parts))
    return {"candidates": candidates}
