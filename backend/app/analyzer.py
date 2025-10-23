import os, json, re
from collections import Counter
CFG = json.load(open(os.path.join(os.path.dirname(__file__), '..', 'config.json')))
from .storage import load_maps, save_maps

def run_analysis():
    maps = load_maps()
    rows_file = CFG['rows_jsonl']
    length_counter = Counter()
    token_counter = Counter()
    tail_triads = Counter()
    total = 0
    if not os.path.exists(rows_file):
        save_maps(maps)
        return maps
    with open(rows_file, 'r', encoding='utf-8') as f:
        for line in f:
            rec = json.loads(line)
            s = rec.get('serial_b85','') or rec.get('serial','')
            if not s: continue
            total += 1
            length_counter[len(s)] += 1
            tail_triads[s[-3:]] += 1 if len(s)>=3 else 0
            tokens = re.findall(r"[A-Za-z0-9]+", s)
            for t in tokens:
                token_counter[t] += 1
    maps['_stats'] = {
        "total_serials": total,
        "common_lengths": length_counter.most_common(10),
        "top_tokens": token_counter.most_common(200),
        "top_tail_triads": tail_triads.most_common(200)
    }
    save_maps(maps)
    return maps
