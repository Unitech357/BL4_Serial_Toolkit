import React, { useState } from 'react';
import { generateCandidates } from '../api';

export default function GeneratorTab({ maps }) {
  const [params, setParams] = useState({ type: '', manufacturer: '', rarity: ''});
  const [cands, setCands] = useState([]);

  async function onGenerate() {
    const res = await generateCandidates(params);
    setCands(res.candidates || []);
  }

  return (
    <div>
      <h3>Generator</h3>
      <div>
        <input placeholder="type" value={params.type} onChange={e=>setParams({...params, type:e.target.value})}/>
        <input placeholder="manufacturer" value={params.manufacturer} onChange={e=>setParams({...params, manufacturer:e.target.value})}/>
        <input placeholder="rarity" value={params.rarity} onChange={e=>setParams({...params, rarity:e.target.value})}/>
        <button onClick={onGenerate}>Generate</button>
      </div>
      <div style={{marginTop:12}}>
        <strong>Candidates:</strong>
        <ul>
          {cands.map((c,i)=> <li key={i}><code>{c}</code></li>)}
        </ul>
      </div>
    </div>
  );
}
