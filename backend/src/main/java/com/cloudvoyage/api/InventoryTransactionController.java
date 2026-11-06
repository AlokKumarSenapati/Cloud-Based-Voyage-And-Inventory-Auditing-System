package com.cloudvoyage.api;

import java.net.URI;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/transactions")
public class InventoryTransactionController {

    private final InventoryTransactionRepository transactionRepository;

    public InventoryTransactionController(InventoryTransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    @GetMapping
    public List<InventoryTransaction> findAll(@RequestParam(required = false) String sku,
                                              @RequestParam(required = false) String location) {
        if (sku != null && !sku.isBlank()) {
            return transactionRepository.findBySkuOrderByTimestampDesc(sku);
        }
        if (location != null && !location.isBlank()) {
            return transactionRepository.findByLocationOrderByTimestampDesc(location);
        }
        return transactionRepository.findAll();
    }

    @PostMapping
    public ResponseEntity<InventoryTransaction> recordTransaction(@RequestBody InventoryTransaction transaction) {
        InventoryTransaction saved = transactionRepository.save(transaction);
        return ResponseEntity.created(URI.create("/api/transactions/" + saved.getId())).body(saved);
    }
}

