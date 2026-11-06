export const voyages = [
  { id: 'VYG-2026-041', route: 'Mumbai → Dubai', vessel: 'MV Ocean Star', eta: '16 Aug, 18:30', status: 'In transit', progress: 72 },
  { id: 'VYG-2026-042', route: 'Chennai → Singapore', vessel: 'Pacific Horizon', eta: '17 Aug, 09:00', status: 'Loading', progress: 28 },
  { id: 'VYG-2026-038', route: 'Kolkata → Colombo', vessel: 'Blue Meridian', eta: 'Arrived', status: 'Completed', progress: 100 },
]

export const inventory = [
  { sku: 'ELC-1204', item: 'Navigation Sensor', location: 'Mumbai Port Warehouse', quantity: 184, reorder: 80, status: 'Healthy' },
  { sku: 'SPT-4012', item: 'Hydraulic Seal Kit', location: 'Chennai Depot', quantity: 42, reorder: 60, status: 'Low stock' },
  { sku: 'MEC-2351', item: 'Engine Filter', location: 'Kolkata Warehouse', quantity: 319, reorder: 100, status: 'Healthy' },
  { sku: 'SAF-0788', item: 'Marine Safety Vest', location: 'Mumbai Port Warehouse', quantity: 26, reorder: 40, status: 'Low stock' },
]

export const audits = [
  { id: 'AUD-2026-118', location: 'Mumbai Port Warehouse', auditor: 'Aarav Sharma', date: '15 Aug 2026', variance: 0, status: 'Blockchain verified' },
  { id: 'AUD-2026-117', location: 'Chennai Depot', auditor: 'Nisha Patel', date: '14 Aug 2026', variance: -18, status: 'Action required' },
  { id: 'AUD-2026-116', location: 'Kolkata Warehouse', auditor: 'Vikram Rao', date: '13 Aug 2026', variance: 2, status: 'Blockchain verified' },
]
