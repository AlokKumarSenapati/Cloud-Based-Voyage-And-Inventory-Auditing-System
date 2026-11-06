package com.cloudvoyage.api;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InventoryTransactionRepository extends JpaRepository<InventoryTransaction, Long> {

    List<InventoryTransaction> findBySkuOrderByTimestampDesc(String sku);

    List<InventoryTransaction> findByLocationOrderByTimestampDesc(String location);

    List<InventoryTransaction> findByReferenceCodeOrderByTimestampDesc(String referenceCode);
}

