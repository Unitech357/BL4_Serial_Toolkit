import React, { useState } from 'react';
import { decodeSerial } from '../api';
import SerialHighlighter from './SerialHighlighter';
import HudSummary from './HudSummary';

export default function ViewerTab({ maps }) {
  const [serial, setSerial] = useState('');
  const [decoded, setDecoded] = useState(null);

  async function doDecode() {
    const res = await decodeSerial(serial);
    setDecoded(res);
  }

  return (
    <div>
      <h3>Viewer</h3>
      <div>
        <input style={{width:'80%'}} placeholder="Paste a serial here" value={serial} onChange={e => setSerial(e.target.value)} />
        <button onClick={doDecode}>Decode</button>
      </div>
      <div style={{marginTop:12}}>
        {decoded ? (
          <>
            <SerialHighlighter serial={decoded.serial} segments={decoded.segments} />
            <HudSummary hud={decoded.hud} confidence={decoded.confidence} fields={decoded.fields} />
          </>
        ) : <div>Decoded output will appear here.</div>}
      </div>
    </div>
  );
}
