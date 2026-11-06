package com.cloudvoyage.api;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "locations")
public class Location {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 30)
    private String code;

    @Column(nullable = false, length = 120)
    private String name;

    @Column(nullable = false, length = 30)
    private String type; // PORT, WAREHOUSE, DEPOT

    @Column(nullable = false, length = 80)
    private String city;

    @Column(nullable = false, length = 80)
    private String country;

    protected Location() {
    }

    public Location(String code, String name, String type, String city, String country) {
        this.code = code;
        this.name = name;
        this.type = type;
        this.city = city;
        this.country = country;
    }

    public Long getId() { return id; }
    public String getCode() { return code; }
    public String getName() { return name; }
    public String getType() { return type; }
    public String getCity() { return city; }
    public String getCountry() { return country; }

    public void update(String code, String name, String type, String city, String country) {
        this.code = code;
        this.name = name;
        this.type = type;
        this.city = city;
        this.country = country;
    }
}

