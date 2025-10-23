import React, { useState, useEffect } from 'react';
import ImportTab from './components/ImportTab';
import ViewerTab from './components/ViewerTab';
import GeneratorTab from './components/GeneratorTab';
import SettingsTab from './components/SettingsTab';
import { getMaps } from './api';

export default function App() {
  const [tab, setTab] = useState('import');
  const [maps, setMaps] = useState(null);

  useEffect(() => {
    async function load() {
      try {
        const m = await getMaps();
        setMaps(m);
      } catch (e) {
        // backend may not be running yet
      }
    }
    load();
  }, []);

  return (
    <div className="app-shell">
      <div className="header">
        <h2>BL4 Serial Toolkit</h2>
        <div style={{marginLeft:'auto'}}>
          <button onClick={() => setTab('import')}>Import</button>
          <button onClick={() => setTab('viewer')}>Viewer</button>
          <button onClick={() => setTab('generator')}>Generator</button>
          <button onClick={() => setTab('settings')}>Settings</button>
        </div>
      </div>

      <div className="card">
        {tab === 'import' && <ImportTab onImported={() => getMaps().then(setMaps)} />}
        {tab === 'viewer' && <ViewerTab maps={maps} />}
        {tab === 'generator' && <GeneratorTab maps={maps} />}
        {tab === 'settings' && <SettingsTab maps={maps} />}
      </div>
    </div>
  );
}
