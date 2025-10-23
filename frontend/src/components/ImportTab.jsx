import React, { useState } from 'react';
import { importCsv } from '../api';

export default function ImportTab({ onImported }) {
  const [file, setFile] = useState(null);
  const [status, setStatus] = useState('');

  async function handleUpload() {
    if (!file) return setStatus('Select a file first');
    setStatus('Uploading...');
    try {
      const res = await importCsv(file);
      setStatus(`Imported ${res.rows || 0} rows. Maps saved.`);
      if (onImported) onImported();
    } catch (e) {
      setStatus('Import failed: ' + (e.message || e));
    }
  }

  return (
    <div>
      <h3>Import CSV</h3>
      <input type="file" accept=".csv,.txt" onChange={e => setFile(e.target.files[0])} />
      <div style={{marginTop:8}}>
        <button onClick={handleUpload}>Upload & Process</button>
      </div>
      <div style={{marginTop:8}}><strong>Status:</strong> {status}</div>
      <div style={{marginTop:8}}>
        Tip: if you hit encoding problems, re-save the CSV as UTF-8 (text editor) and re-upload.
      </div>
    </div>
  );
}
