package com.cloudvoyage.api;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "voyages")
public class Voyage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 40)
    private String referenceNumber;

    @Column(nullable = false, length = 100)
    private String origin;

    @Column(nullable = false, length = 100)
    private String destination;

    @Column(nullable = false, length = 120)
    private String vessel;

    @Column(nullable = false)
    private LocalDateTime eta;

    @Column(nullable = false, length = 30)
    private String status;

    @Column(nullable = false)
    private int progress;

    protected Voyage() {
    }

    public Voyage(String referenceNumber, String origin, String destination, String vessel,
                  LocalDateTime eta, String status, int progress) {
        this.referenceNumber = referenceNumber;
        this.origin = origin;
        this.destination = destination;
        this.vessel = vessel;
        this.eta = eta;
        this.status = status;
        this.progress = progress;
    }

    public Long getId() { return id; }
    public String getReferenceNumber() { return referenceNumber; }
    public String getOrigin() { return origin; }
    public String getDestination() { return destination; }
    public String getVessel() { return vessel; }
    public LocalDateTime getEta() { return eta; }
    public String getStatus() { return status; }
    public int getProgress() { return progress; }

    @Transient
    public String getRoute() {
        return origin + " → " + destination;
    }

    public void update(String referenceNumber, String origin, String destination, String vessel,
                       LocalDateTime eta, String status, int progress) {
        this.referenceNumber = referenceNumber;
        this.origin = origin;
        this.destination = destination;
        this.vessel = vessel;
        this.eta = eta;
        this.status = status;
        this.progress = progress;
    }
}
