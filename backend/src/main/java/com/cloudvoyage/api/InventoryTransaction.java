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
@Table(name = "inventory_transactions")
public class InventoryTransaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 30)
    private String transactionType; // DISPATCH, RECEIPT, ADJUSTMENT, AUDIT_CORRECTION

    @Column(nullable = false, length = 40)
    private String sku;

    @Column(nullable = false, length = 120)
    private String location;

    @Column(length = 120)
    private String destinationLocation;

    @Column(nullable = false)
    private int quantity;

    @Column(length = 50)
    private String referenceCode; // Voyage ID or Audit Code

    @Column(nullable = false, length = 50)
    private String performedBy;

    @Column(length = 255)
    private String remarks;

    @Column(nullable = false)
    private LocalDateTime timestamp;

    protected InventoryTransaction() {
    }

    public InventoryTransaction(String transactionType, String sku, String location,
                                String destinationLocation, int quantity, String referenceCode,
                                String performedBy, String remarks) {
        this.transactionType = transactionType;
        this.sku = sku;
        this.location = location;
        this.destinationLocation = destinationLocation;
        this.quantity = quantity;
        this.referenceCode = referenceCode;
        this.performedBy = performedBy;
        this.remarks = remarks;
    }

    @PrePersist
    protected void onCreate() {
        if (timestamp == null) {
            timestamp = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public String getTransactionType() { return transactionType; }
    public String getSku() { return sku; }
    public String getLocation() { return location; }
    public String getDestinationLocation() { return destinationLocation; }
    public int getQuantity() { return quantity; }
    public String getReferenceCode() { return referenceCode; }
    public String getPerformedBy() { return performedBy; }
    public String getRemarks() { return remarks; }
    public LocalDateTime getTimestamp() { return timestamp; }
}

