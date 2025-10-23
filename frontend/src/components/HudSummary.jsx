import React from 'react';

export default function HudSummary({ hud, confidence, fields }) {
  return (
    <div className="hud">
      <div><strong>Confidence:</strong> {confidence}</div>
      <div><strong>Fields:</strong> {JSON.stringify(fields)}</div>
      <div style={{marginTop:8}}>
        <strong>Estimated Performance</strong>
        <div>Damage: {hud?.damage}</div>
        <div>Stability: {hud?.stability}</div>
      </div>
    </div>
  );
}
