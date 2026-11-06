# Phase 1: Project Planning and Architecture

## 1. Project scope

The Cloud Voyage & Inventory Auditing System supports a logistics organization that moves cargo between locations and needs a reliable, auditable record of stock movements.

The application will manage:

- users and role-based access;
- locations (warehouses, ports, or depots);
- inventory items and stock levels;
- voyages and cargo assignments;
- dispatch and receipt of cargo;
- physical inventory audits and discrepancy resolution;
- audit-report storage and blockchain integrity verification.

## 2. User roles

| Role | Main permissions |
| --- | --- |
| Administrator | Manage users, roles, locations, item master data, and system settings. |
| Manager | Create voyages, allocate cargo, view reports, and approve audit resolutions. |
| Operator | Record dispatches, receipts, and inventory movements. |
| Auditor | Create audits, enter physical counts, add remarks, and submit audits. |

## 3. Functional workflow

```text
Set up locations and items
        -> Create a voyage and assign cargo
        -> Dispatch cargo from origin inventory
        -> Track voyage status (planned, in transit, completed)
        -> Receive cargo at destination inventory
        -> Conduct physical inventory audit
        -> Calculate stock variance and submit report
        -> Hash the final report and register the hash on blockchain
        -> Verify report integrity whenever required
```

## 4. Architecture

```text
React web application
        |
        | HTTPS / JSON REST API
        v
Spring Boot backend ------------------> Blockchain RPC / AuditRegistry contract
        |
        +--> MySQL (application data)
        |
        +--> Object storage (audit PDFs and evidence images)
```

The database remains the source of business data. Blockchain stores only a final audit identifier, report hash, wallet address, timestamp, and transaction hash. This protects report integrity without exposing operational data or incurring unnecessary on-chain cost.

## 5. Initial data model

```text
User
Location
Item
InventoryBalance
InventoryTransaction
Voyage
VoyageCargo
Audit
AuditDetail
AuditReport
BlockchainTransaction
```

Key relationships:

```text
Location 1---* InventoryBalance *---1 Item
Voyage 1---* VoyageCargo *---1 Item
Audit 1---* AuditDetail *---1 Item
Audit 1---1 AuditReport 1---1 BlockchainTransaction
```

## 6. Delivery phases

1. **Planning and repository setup** — requirements, architecture, folder layout, documentation.
2. **Backend foundation** — Spring Boot, MySQL, entities, migrations, and error handling.
3. **Security and master data** — JWT authentication; users, locations, and item APIs.
4. **Inventory and voyage workflow** — stock transactions, cargo assignment, dispatch, and receipt.
5. **Auditing and blockchain** — audit reports, SHA-256 hashing, Solidity registry contract, verification.
6. **Frontend** — React dashboard and role-aware screens. The presentation shell can be started early with mock data, then integrated once APIs are available.
7. **Cloud deployment and final testing** — AWS deployment, file storage, monitoring, API/UI tests, presentation assets.

## 7. Quality and security requirements

- Validate all API input and return consistent error responses.
- Protect APIs with JWT and role-based authorization.
- Never store passwords as plain text; use BCrypt hashes.
- Keep private keys and database passwords only in environment variables or cloud secret management.
- Record timestamps and the user responsible for important inventory and audit actions.
- Ensure inventory movements are transactional so stock cannot be partially updated.
- Use SHA-256 hashes to verify audit-report integrity.

## 8. Phase 1 completion criteria

- Scope, roles, architecture, technology decisions, and delivery sequence are documented.
- Repository has separate frontend, backend, blockchain, and docs areas.
- The next approved task is to initialize the Spring Boot backend and connect it to MySQL.
