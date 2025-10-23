import React from 'react';

export default function SerialHighlighter({ serial, segments }) {
  // segments: list of [start,end,tag] or tuples
  // For safety convert to normalized segments
  const segs = (segments || []).map(s => {
    if (Array.isArray(s)) return { start: s[0], end: s[1], tag: s[2] };
    if (s && typeof s === 'object') return s;
    return null;
  }).filter(Boolean).sort((a,b)=>a.start-b.start);

  let parts = [];
  let cursor = 0;
  segs.forEach((s,idx) => {
    if (s.start > cursor) {
      parts.push({ text: serial.slice(cursor, s.start), tag: null });
    }
    parts.push({ text: serial.slice(s.start, s.end), tag: s.tag });
    cursor = s.end;
  });
  if (cursor < serial.length) parts.push({ text: serial.slice(cursor), tag: null });

  const colorFor = (tag) => {
    if (!tag) return '#333';
    if (tag.includes('manufacturer')) return '#c23531';
    if (tag.includes('type')) return '#2f4554';
    if (tag.includes('rarity')) return '#61a0a8';
    if (tag.includes('element')) return '#d48265';
    return '#91c7ae';
  };

  return (
    <div>
      <div className="serial-highlight">
        {parts.map((p,i) => (
          <span key={i} style={{color: colorFor(p.tag), paddingRight:2}}>
            {p.text}
          </span>
        ))}
      </div>
    </div>
  );
}
