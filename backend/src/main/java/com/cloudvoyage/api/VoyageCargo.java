package com.cloudvoyage.api;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "voyage_cargo")
public class VoyageCargo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 40)
    private String voyageReference;

    @Column(nullable = false, length = 40)
    private String sku;

    @Column(nullable = false, length = 120)
    private String itemName;

    @Column(nullable = false)
    private int quantity;

    @Column(nullable = false, length = 30)
    private String unit;

    @Column(nullable = false, length = 30)
    private String status; // LOADED, IN_TRANSIT, DISCHARGED

    protected VoyageCargo() {
    }

    public VoyageCargo(String voyageReference, String sku, String itemName, int quantity, String unit, String status) {
        this.voyageReference = voyageReference;
        this.sku = sku;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unit = unit;
        this.status = status;
    }

    public Long getId() { return id; }
    public String getVoyageReference() { return voyageReference; }
    public String getSku() { return sku; }
    public String getItemName() { return itemName; }
    public int getQuantity() { return quantity; }
    public String getUnit() { return unit; }
    public String getStatus() { return status; }

    public void updateStatus(String status) {
        this.status = status;
    }
}

