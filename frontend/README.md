# CloudVoyage frontend

This React + Vite interface is the operational dashboard for voyages, inventory, audits, and blockchain report verification.

## Screens included

- Dashboard: operations metrics, active voyages, attention queue, and recent audits
- Voyages: journey-progress overview
- Inventory: item-level stock overview and reorder alerts
- Audits: audit history and verification status
- Verify report: blockchain-verification demonstration screen

## Run locally

1. Install Node.js 20 LTS or newer.
2. In this folder, run `npm install`.
3. Run `npm run dev`.
4. Open the local URL shown by Vite.

The current screens use local mock data from `src/data/mockData.js`. The next integration step is to replace it with calls to the Spring Boot REST API.
