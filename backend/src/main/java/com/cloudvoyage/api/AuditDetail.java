package com.cloudvoyage.api;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "audit_details")
public class AuditDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 40)
    private String auditCode;

    @Column(nullable = false, length = 40)
    private String sku;

    @Column(nullable = false, length = 120)
    private String itemName;

    @Column(nullable = false)
    private int systemCount;

    @Column(nullable = false)
    private int physicalCount;

    @Column(nullable = false)
    private int variance;

    @Column(length = 255)
    private String remarks;

    protected AuditDetail() {
    }

    public AuditDetail(String auditCode, String sku, String itemName, int systemCount, int physicalCount, String remarks) {
        this.auditCode = auditCode;
        this.sku = sku;
        this.itemName = itemName;
        this.systemCount = systemCount;
        this.physicalCount = physicalCount;
        this.variance = physicalCount - systemCount;
        this.remarks = remarks;
    }

    public Long getId() { return id; }
    public String getAuditCode() { return auditCode; }
    public String getSku() { return sku; }
    public String getItemName() { return itemName; }
    public int getSystemCount() { return systemCount; }
    public int getPhysicalCount() { return physicalCount; }
    public int getVariance() { return variance; }
    public String getRemarks() { return remarks; }
}

