-- =====================================================================
-- Cloud Voyage & Inventory Auditing System - Production Schema
-- Target Database: MySQL 8.0+ / 8.4
-- =====================================================================

CREATE DATABASE IF NOT EXISTS cloud_voyage_audit;
USE cloud_voyage_audit;

-- 1. Users & Roles
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Locations (Ports, Warehouses, Depots)
CREATE TABLE IF NOT EXISTS locations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    type VARCHAR(30) NOT NULL,
    city VARCHAR(80) NOT NULL,
    country VARCHAR(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Inventory Items
CREATE TABLE IF NOT EXISTS inventory_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(40) NOT NULL UNIQUE,
    item_name VARCHAR(120) NOT NULL,
    location VARCHAR(120) NOT NULL,
    quantity INT NOT NULL,
    reorder_level INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Voyages
CREATE TABLE IF NOT EXISTS voyages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    reference_number VARCHAR(40) NOT NULL UNIQUE,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    vessel VARCHAR(120) NOT NULL,
    eta DATETIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    progress INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Voyage Cargo (Manifest)
CREATE TABLE IF NOT EXISTS voyage_cargo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    voyage_reference VARCHAR(40) NOT NULL,
    sku VARCHAR(40) NOT NULL,
    item_name VARCHAR(120) NOT NULL,
    quantity INT NOT NULL,
    unit VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Inventory Audits
CREATE TABLE IF NOT EXISTS inventory_audits (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    audit_code VARCHAR(40) NOT NULL UNIQUE,
    location VARCHAR(120) NOT NULL,
    auditor VARCHAR(120) NOT NULL,
    audit_date DATE NOT NULL,
    variance INT NOT NULL,
    status VARCHAR(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Audit Details (Line items & counts)
CREATE TABLE IF NOT EXISTS audit_details (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    audit_code VARCHAR(40) NOT NULL,
    sku VARCHAR(40) NOT NULL,
    item_name VARCHAR(120) NOT NULL,
    system_count INT NOT NULL,
    physical_count INT NOT NULL,
    variance INT NOT NULL,
    remarks VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Blockchain Audit Records (Immutable proofs)
CREATE TABLE IF NOT EXISTS blockchain_audit_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    audit_code VARCHAR(40) NOT NULL UNIQUE,
    report_hash VARCHAR(66) NOT NULL,
    tx_hash VARCHAR(66) NOT NULL,
    network VARCHAR(60) NOT NULL,
    contract_address VARCHAR(42) NOT NULL,
    wallet_address VARCHAR(42) NOT NULL,
    registered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Inventory Movement & Audit Ledger
CREATE TABLE IF NOT EXISTS inventory_transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    transaction_type VARCHAR(30) NOT NULL,
    sku VARCHAR(40) NOT NULL,
    location VARCHAR(120) NOT NULL,
    destination_location VARCHAR(120),
    quantity INT NOT NULL,
    reference_code VARCHAR(50),
    performed_by VARCHAR(50) NOT NULL,
    remarks VARCHAR(255),
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

