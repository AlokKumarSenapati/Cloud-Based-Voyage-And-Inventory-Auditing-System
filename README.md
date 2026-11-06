# Cloud Voyage & Inventory Auditing System

A cloud-first, full-stack logistics application for tracking voyages, managing inventory, conducting physical audits, and preserving immutable proof of audit reports on a blockchain.

## Project objectives

- Track cargo from an origin location to a destination location.
- Maintain item-level inventory across warehouses.
- Record inventory movements and physical stock audits.
- Identify, explain, and resolve stock discrepancies.
- Generate audit reports and store their integrity proof on a blockchain.
- Deploy the application and its data services to the cloud.

## Planned technology stack

| Area | Planned technology |
| --- | --- |
| Frontend | React + Vite + Tailwind CSS |
| Backend | Java 25 LTS + Spring Boot + Maven |
| Security | Spring Security + JWT |
| Database | MySQL |
| Blockchain | Solidity + Hardhat + Polygon Amoy testnet |
| Cloud | AWS (S3, RDS, EC2 or Elastic Beanstalk, CloudWatch) |

## Repository layout

```text
frontend/      React dashboard (initial foundation created)
backend/       Spring Boot REST API (planned next)
blockchain/    Solidity contract and deployment scripts (planned)
docs/          Design, database, API, and deployment documentation
```

See [Phase 1 project plan](docs/phase-1-project-plan.md) for the approved foundation and implementation order.
