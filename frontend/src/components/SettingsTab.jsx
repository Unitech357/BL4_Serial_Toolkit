import React from 'react';

export default function SettingsTab({ maps }) {
  return (
    <div>
      <h3>Settings</h3>
      <div>
        <p>Maps status: {maps ? 'Loaded' : 'Not loaded'}</p>
        <p>Cache dir: backend/cache/ (created at runtime)</p>
        <p>If ingestion fails see backend logs and check file encoding.</p>
      </div>
    </div>
  );
}
