package com.cloudvoyage.api;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "inventory_items")
public class InventoryItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 40)
    private String sku;

    @Column(nullable = false, length = 120)
    private String itemName;

    @Column(nullable = false, length = 120)
    private String location;

    @Column(nullable = false)
    private int quantity;

    @Column(nullable = false)
    private int reorderLevel;

    protected InventoryItem() {
    }

    public InventoryItem(String sku, String itemName, String location, int quantity, int reorderLevel) {
        this.sku = sku;
        this.itemName = itemName;
        this.location = location;
        this.quantity = quantity;
        this.reorderLevel = reorderLevel;
    }

    public Long getId() { return id; }
    public String getSku() { return sku; }
    public String getItemName() { return itemName; }
    public String getLocation() { return location; }
    public int getQuantity() { return quantity; }
    public int getReorderLevel() { return reorderLevel; }

    public void update(String sku, String itemName, String location, int quantity, int reorderLevel) {
        this.sku = sku;
        this.itemName = itemName;
        this.location = location;
        this.quantity = quantity;
        this.reorderLevel = reorderLevel;
    }

    @Transient
    public String getStatus() {
        return quantity <= reorderLevel ? "Low stock" : "Healthy";
    }
}
