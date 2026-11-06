package com.cloudvoyage.api;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface InventoryRepository extends JpaRepository<InventoryItem, Long> {
    List<InventoryItem> findAllByOrderByItemNameAsc();
}
