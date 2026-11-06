const BASE_URL = (typeof window !== 'undefined' && (window.location.port === '5173' || window.location.port === '5174'))
  ? 'http://localhost:8080/api'
  : '/api';

export async function fetchInventory() {
  const res = await fetch(`${BASE_URL}/inventory`);
  if (!res.ok) throw new Error('Failed to fetch inventory');
  return res.json();
}

export async function fetchVoyages() {
  const res = await fetch(`${BASE_URL}/voyages`);
  if (!res.ok) throw new Error('Failed to fetch voyages');
  return res.json();
}

export async function fetchAudits() {
  const res = await fetch(`${BASE_URL}/audits`);
  if (!res.ok) throw new Error('Failed to fetch audits');
  return res.json();
}

export async function fetchDashboardSummary() {
  const res = await fetch(`${BASE_URL}/dashboard/summary`);
  if (!res.ok) throw new Error('Failed to fetch summary');
  return res.json();
}

export async function createVoyage(voyage) {
  const res = await fetch(`${BASE_URL}/voyages`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(voyage)
  });
  if (!res.ok) throw new Error('Failed to create voyage');
  return res.json();
}

export async function createInventoryItem(item) {
  const res = await fetch(`${BASE_URL}/inventory`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(item)
  });
  if (!res.ok) throw new Error('Failed to create inventory item');
  return res.json();
}

export async function createAudit(audit) {
  const res = await fetch(`${BASE_URL}/audits`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(audit)
  });
  if (!res.ok) throw new Error('Failed to create audit');
  return res.json();
}

export async function fetchCaptcha() {
  const res = await fetch(`${BASE_URL}/auth/captcha`);
  if (!res.ok) throw new Error('Failed to load Captcha challenge');
  return res.json();
}

export async function loginUser(credentials) {
  const res = await fetch(`${BASE_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(credentials)
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || 'Login failed. Please check your credentials.');
  return data;
}

export async function registerUser(details) {
  const res = await fetch(`${BASE_URL}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(details)
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.message || 'Registration failed.');
  return data;
}

