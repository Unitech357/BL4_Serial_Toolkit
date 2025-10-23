import os, json, re
CFG = json.load(open(os.path.join(os.path.dirname(__file__), '..', 'config.json')))
maps_path = os.path.join(os.path.dirname(__file__), '..', CFG['maps_json']) if False else os.path.join(os.path.dirname(__file__), '..', 'cache', 'maps.json')

def load_maps():
    mp = os.path.join(os.path.dirname(__file__), '..', CFG['maps_json'])
    if os.path.exists(mp):
        return json.load(open(mp, 'r', encoding='utf-8'))
    return {}

def decode(serial):
    maps = load_maps()
    s = (serial or "").strip()
    out = {"serial": s, "segments": [], "fields": {}, "confidence": 0.0, "hud": {}}
    # simple tokenization
    tokens = re.findall(r"[A-Za-z0-9]{1,}", s)
    token_matches = []
    for t in sorted(tokens, key=lambda x: -len(x)):
        idx = s.find(t)
        if idx >= 0:
            token_matches.append((idx, idx+len(t), t))
    manufacturers = set(k.lower() for k in maps.get('manufacturer',{}) if k)
    types = set(k.lower() for k in maps.get('type',{}) if k)
    rarities = set(k.lower() for k in maps.get('rarity',{}) if k)
    elements = set(k.lower() for k in maps.get('element',{}) if k)
    tags = []
    assigned = {}
    for st,en,t in token_matches:
        low = t.lower()
        tag = 'token'
        if low in manufacturers:
            assigned['manufacturer'] = t
            tag = 'manufacturer'
        elif low in types:
            assigned['type'] = t
            tag = 'type'
        elif low in rarities:
            assigned['rarity'] = t
            tag = 'rarity'
        elif low in elements:
            assigned['element'] = t
            tag = 'element'
        tags.append([st,en,tag])
    out['segments'] = tags
    out['fields'] = assigned
    conf = 0.0
    if 'manufacturer' in assigned: conf += 0.3
    if 'type' in assigned: conf += 0.3
    if 'rarity' in assigned: conf += 0.2
    if 'element' in assigned: conf += 0.1
    out['confidence'] = round(min(1.0, conf), 3)
    rarity = assigned.get('rarity','').lower()
    est = {}
    if 'legendary' in rarity or 'epic' in rarity:
        est['damage'] = 'High'
        est['stability'] = 'Medium'
    elif 'rare' in rarity:
        est['damage'] = 'Medium'
        est['stability'] = 'Medium'
    else:
        est['damage'] = 'Low'
        est['stability'] = 'Low'
    out['hud'] = est
    return out
