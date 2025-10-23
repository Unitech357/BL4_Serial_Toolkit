import os, json
import pandas as pd
from pathlib import Path
CFG = json.load(open(os.path.join(os.path.dirname(__file__), '..', 'config.json')))

def ingest_csv(csv_path, chunksize=None):
    chunksize = chunksize or CFG.get('chunksize', 5000)
    out_path = CFG['rows_jsonl']
    Path(os.path.dirname(out_path)).mkdir(parents=True, exist_ok=True)
    written = 0
    encodings = CFG.get('csv_encoding_fallbacks', ['utf-8','utf-8-sig','latin1','cp1252'])
    for enc in encodings:
        try:
            with open(out_path, 'w', encoding='utf-8') as out_f:
                for chunk in pd.read_csv(csv_path, chunksize=chunksize, dtype=str, encoding=enc, keep_default_na=False):
                    for row in chunk.fillna('').to_dict(orient='records'):
                        rec = {
                            "id": row.get("id",""),
                            "serial_b85": row.get("serial_b85","") or row.get("serial",""),
                            "deserialized_raw": row.get("deserialized_raw",""),
                            "deserialized_type": row.get("deserialized_type",""),
                            "deserialized_manufacturer": row.get("deserialized_manufacturer",""),
                            "original_name": row.get("original_name",""),
                            "original_rarity": row.get("original_rarity",""),
                            "original_element": row.get("original_element",""),
                            "parts_joined": row.get("parts_joined","")
                        }
                        out_f.write(json.dumps(rec, ensure_ascii=False) + "\n")
                        written += 1
            return written
        except Exception as e:
            # try next encoding
            continue
    raise Exception("Failed to parse CSV with fallback encodings")
