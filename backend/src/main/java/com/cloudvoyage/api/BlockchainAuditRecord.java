package com.cloudvoyage.api;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "blockchain_audit_records")
public class BlockchainAuditRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 40)
    private String auditCode;

    @Column(nullable = false, length = 66) // 0x + 64 hex chars
    private String reportHash;

    @Column(nullable = false, length = 66)
    private String txHash;

    @Column(nullable = false, length = 60)
    private String network; // e.g., Polygon Amoy testnet

    @Column(nullable = false, length = 42)
    private String contractAddress;

    @Column(nullable = false, length = 42)
    private String walletAddress;

    @Column(nullable = false)
    private LocalDateTime registeredAt;

    protected BlockchainAuditRecord() {
    }

    public BlockchainAuditRecord(String auditCode, String reportHash, String txHash,
                                 String network, String contractAddress, String walletAddress) {
        this.auditCode = auditCode;
        this.reportHash = reportHash;
        this.txHash = txHash;
        this.network = network;
        this.contractAddress = contractAddress;
        this.walletAddress = walletAddress;
    }

    @PrePersist
    protected void onCreate() {
        if (registeredAt == null) {
            registeredAt = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public String getAuditCode() { return auditCode; }
    public String getReportHash() { return reportHash; }
    public String getTxHash() { return txHash; }
    public String getNetwork() { return network; }
    public String getContractAddress() { return contractAddress; }
    public String getWalletAddress() { return walletAddress; }
    public LocalDateTime getRegisteredAt() { return registeredAt; }
}

