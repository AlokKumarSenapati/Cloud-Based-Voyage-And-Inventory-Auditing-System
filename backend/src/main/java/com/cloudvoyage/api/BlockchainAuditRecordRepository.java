package com.cloudvoyage.api;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BlockchainAuditRecordRepository extends JpaRepository<BlockchainAuditRecord, Long> {

    Optional<BlockchainAuditRecord> findByAuditCode(String auditCode);

    Optional<BlockchainAuditRecord> findByReportHash(String reportHash);
}

