import os, json
CFG = json.load(open(os.path.join(os.path.dirname(__file__), '..', 'config.json')))

def load_maps():
    mp = CFG['maps_json']
    if os.path.exists(mp):
        return json.load(open(mp, 'r', encoding='utf-8'))
    # default empty maps
    return {"manufacturer":{}, "type":{}, "rarity":{}, "element":{}, "parts_vocab":{}, "_stats":{}}

def save_maps(maps):
    with open(CFG['maps_json'], 'w', encoding='utf-8') as f:
        json.dump(maps, f, ensure_ascii=False, indent=2)
