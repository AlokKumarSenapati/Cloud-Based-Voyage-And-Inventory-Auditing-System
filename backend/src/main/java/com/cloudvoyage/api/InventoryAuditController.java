package com.cloudvoyage.api;

import java.net.URI;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/audits")
public class InventoryAuditController {

    private final InventoryAuditRepository auditRepository;

    public InventoryAuditController(InventoryAuditRepository auditRepository) {
        this.auditRepository = auditRepository;
    }

    @GetMapping
    public List<InventoryAudit> findAll() {
        return auditRepository.findAllByOrderByAuditDateDesc();
    }

    @GetMapping("/{id}")
    public InventoryAudit findById(@PathVariable Long id) {
        return auditRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Audit not found"));
    }

    @PostMapping
    public ResponseEntity<InventoryAudit> create(@Valid @RequestBody InventoryAuditRequest request) {
        InventoryAudit audit = new InventoryAudit(
                request.auditCode(), request.location(), request.auditor(), request.auditDate(),
                request.variance(), request.status());
        InventoryAudit saved = auditRepository.save(audit);
        return ResponseEntity.created(URI.create("/api/audits/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public InventoryAudit update(@PathVariable Long id, @Valid @RequestBody InventoryAuditRequest request) {
        InventoryAudit audit = findById(id);
        audit.update(
                request.auditCode(), request.location(), request.auditor(), request.auditDate(),
                request.variance(), request.status());
        return auditRepository.save(audit);
    }
}
