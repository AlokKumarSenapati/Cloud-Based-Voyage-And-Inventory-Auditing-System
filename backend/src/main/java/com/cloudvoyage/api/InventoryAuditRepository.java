package com.cloudvoyage.api;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface InventoryAuditRepository extends JpaRepository<InventoryAudit, Long> {
    List<InventoryAudit> findAllByOrderByAuditDateDesc();
}
