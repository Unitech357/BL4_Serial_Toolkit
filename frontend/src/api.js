const API_BASE = import.meta.env.VITE_API_BASE || 'http://127.0.0.1:8000';

export async function importCsv(file, onProgress) {
  const form = new FormData();
  form.append('file', file);
  const res = await fetch(`${API_BASE}/api/import`, {
    method: 'POST',
    body: form
  });
  return res.json();
}

export async function getMaps() {
  const res = await fetch(`${API_BASE}/api/maps`);
  return res.json();
}

export async function decodeSerial(serial) {
  const res = await fetch(`${API_BASE}/api/decode`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ serial })
  });
  return res.json();
}

export async function bulkDecode(serials) {
  const res = await fetch(`${API_BASE}/api/bulk_decode`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ serials })
  });
  return res.json();
}

export async function generateCandidates(params) {
  const res = await fetch(`${API_BASE}/api/generate`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(params)
  });
  return res.json();
}
