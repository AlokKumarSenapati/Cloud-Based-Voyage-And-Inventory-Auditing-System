package com.cloudvoyage.api;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "inventory_audits")
public class InventoryAudit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 40)
    private String auditCode;

    @Column(nullable = false, length = 120)
    private String location;

    @Column(nullable = false, length = 120)
    private String auditor;

    @Column(nullable = false)
    private LocalDate auditDate;

    @Column(nullable = false)
    private int variance;

    @Column(nullable = false, length = 40)
    private String status;

    protected InventoryAudit() {
    }

    public InventoryAudit(String auditCode, String location, String auditor, LocalDate auditDate,
                          int variance, String status) {
        this.auditCode = auditCode;
        this.location = location;
        this.auditor = auditor;
        this.auditDate = auditDate;
        this.variance = variance;
        this.status = status;
    }

    public Long getId() { return id; }
    public String getAuditCode() { return auditCode; }
    public String getLocation() { return location; }
    public String getAuditor() { return auditor; }
    public LocalDate getAuditDate() { return auditDate; }
    public int getVariance() { return variance; }
    public String getStatus() { return status; }

    public void update(String auditCode, String location, String auditor, LocalDate auditDate,
                       int variance, String status) {
        this.auditCode = auditCode;
        this.location = location;
        this.auditor = auditor;
        this.auditDate = auditDate;
        this.variance = variance;
        this.status = status;
    }
}
