package com.cloudvoyage.api;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SampleDataConfiguration {

    @Bean
    CommandLineRunner loadSampleData(InventoryRepository inventoryRepository,
                                     VoyageRepository voyageRepository,
                                     InventoryAuditRepository auditRepository,
                                     UserRepository userRepository,
                                     LocationRepository locationRepository,
                                     VoyageCargoRepository cargoRepository,
                                     AuditDetailRepository auditDetailRepository,
                                     BlockchainAuditRecordRepository blockchainRepository,
                                     InventoryTransactionRepository transactionRepository) {
        return args -> {
            if (locationRepository.count() == 0) {
                locationRepository.saveAll(List.of(
                        new Location("LOC-BOM-01", "Mumbai Port Warehouse", "PORT", "Mumbai", "India"),
                        new Location("LOC-MAA-01", "Chennai Depot", "DEPOT", "Chennai", "India"),
                        new Location("LOC-CCU-01", "Kolkata Warehouse", "WAREHOUSE", "Kolkata", "India"),
                        new Location("LOC-DXB-01", "Dubai Port", "PORT", "Dubai", "UAE"),
                        new Location("LOC-SIN-01", "Singapore Port", "PORT", "Singapore", "Singapore"),
                        new Location("LOC-CMB-01", "Colombo Port", "PORT", "Colombo", "Sri Lanka")
                ));
            }
            if (inventoryRepository.count() == 0) {
                inventoryRepository.saveAll(List.of(
                        new InventoryItem("ELC-1204", "Navigation Sensor", "Mumbai Port Warehouse", 184, 80),
                        new InventoryItem("SPT-4012", "Hydraulic Seal Kit", "Chennai Depot", 42, 60),
                        new InventoryItem("MEC-2351", "Engine Filter", "Kolkata Warehouse", 319, 100),
                        new InventoryItem("SAF-0788", "Marine Safety Vest", "Mumbai Port Warehouse", 26, 40)
                ));
            }

            if (voyageRepository.count() == 0) {
                voyageRepository.saveAll(List.of(
                        new Voyage("VYG-2026-041", "Mumbai", "Dubai", "MV Ocean Star",
                                LocalDateTime.of(2026, 9, 25, 18, 30), "In transit", 72),
                        new Voyage("VYG-2026-042", "Chennai", "Singapore", "Pacific Horizon",
                                LocalDateTime.of(2026, 9, 26, 9, 0), "Loading", 28),
                        new Voyage("VYG-2026-038", "Kolkata", "Colombo", "Blue Meridian",
                                LocalDateTime.of(2026, 9, 20, 14, 0), "Completed", 100)
                ));
            }

            if (cargoRepository.count() == 0) {
                cargoRepository.saveAll(List.of(
                        new VoyageCargo("VYG-2026-041", "ELC-1204", "Navigation Sensor", 30, "units", "IN_TRANSIT"),
                        new VoyageCargo("VYG-2026-041", "MEC-2351", "Engine Filter", 50, "units", "IN_TRANSIT"),
                        new VoyageCargo("VYG-2026-042", "SPT-4012", "Hydraulic Seal Kit", 20, "units", "LOADED"),
                        new VoyageCargo("VYG-2026-038", "SAF-0788", "Marine Safety Vest", 15, "units", "DISCHARGED")
                ));
            }

            if (auditRepository.count() == 0) {
                auditRepository.saveAll(List.of(
                        new InventoryAudit("AUD-2026-118", "Mumbai Port Warehouse", "Aarav Sharma",
                                LocalDate.of(2026, 9, 15), 0, "Blockchain verified"),
                        new InventoryAudit("AUD-2026-117", "Chennai Depot", "Nisha Patel",
                                LocalDate.of(2026, 9, 14), -18, "Action required"),
                        new InventoryAudit("AUD-2026-116", "Kolkata Warehouse", "Vikram Rao",
                                LocalDate.of(2026, 9, 13), 2, "Blockchain verified")
                ));
            }

            if (auditDetailRepository.count() == 0) {
                auditDetailRepository.saveAll(List.of(
                        new AuditDetail("AUD-2026-118", "ELC-1204", "Navigation Sensor", 184, 184, "Exact count verified"),
                        new AuditDetail("AUD-2026-117", "SPT-4012", "Hydraulic Seal Kit", 60, 42, "18 units missing in Chennai Depot audit"),
                        new AuditDetail("AUD-2026-116", "MEC-2351", "Engine Filter", 317, 319, "2 units surplus found in bay 3")
                ));
            }

            if (blockchainRepository.count() == 0) {
                blockchainRepository.saveAll(List.of(
                        new BlockchainAuditRecord("AUD-2026-118",
                                "0x7b4e9f1a2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f",
                                "0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
                                "Polygon Amoy testnet",
                                "0x5FbDB2315678afecb367f032d93F642f64180aa3",
                                "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"),
                        new BlockchainAuditRecord("AUD-2026-116",
                                "0x8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b",
                                "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
                                "Polygon Amoy testnet",
                                "0x5FbDB2315678afecb367f032d93F642f64180aa3",
                                "0x70997970C51812dc3A010C7d01b50e0d17dc79C8")
                ));
            }

            if (transactionRepository.count() == 0) {
                transactionRepository.saveAll(List.of(
                        new InventoryTransaction("RECEIPT", "ELC-1204", "Mumbai Port Warehouse", null, 50, "PO-2026-901", "raj_op", "Initial supplier intake"),
                        new InventoryTransaction("DISPATCH", "ELC-1204", "Mumbai Port Warehouse", "Dubai Port", 30, "VYG-2026-041", "raj_op", "Loaded onto MV Ocean Star"),
                        new InventoryTransaction("AUDIT_CORRECTION", "SPT-4012", "Chennai Depot", null, -18, "AUD-2026-117", "aarav_audit", "Shortage verified during count")
                ));
            }

            if (userRepository.count() == 0) {
                userRepository.saveAll(List.of(
                        new User("alok_admin", "Alok Admin", "alok.admin@cloudvoyage.com", "Password123", "Administrator"),
                        new User("sarah_mgr", "Sarah Manager", "sarah.mgr@cloudvoyage.com", "Password123", "Manager"),
                        new User("raj_op", "Raj Operator", "raj.op@cloudvoyage.com", "Password123", "Operator"),
                        new User("aarav_audit", "Aarav Sharma", "aarav.audit@cloudvoyage.com", "Password123", "Auditor")
                ));
            }
        };
    }
}
