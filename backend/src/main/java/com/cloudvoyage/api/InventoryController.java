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
@RequestMapping("/api/inventory")
public class InventoryController {

    private final InventoryRepository inventoryRepository;

    public InventoryController(InventoryRepository inventoryRepository) {
        this.inventoryRepository = inventoryRepository;
    }

    @GetMapping
    public List<InventoryItem> findAll() {
        return inventoryRepository.findAllByOrderByItemNameAsc();
    }

    @GetMapping("/{id}")
    public InventoryItem findById(@PathVariable Long id) {
        return inventoryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Inventory item not found"));
    }

    @PostMapping
    public ResponseEntity<InventoryItem> create(@Valid @RequestBody InventoryRequest request) {
        InventoryItem item = new InventoryItem(
                request.sku(), request.itemName(), request.location(), request.quantity(), request.reorderLevel());
        InventoryItem saved = inventoryRepository.save(item);
        return ResponseEntity.created(URI.create("/api/inventory/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public InventoryItem update(@PathVariable Long id, @Valid @RequestBody InventoryRequest request) {
        InventoryItem item = findById(id);
        item.update(request.sku(), request.itemName(), request.location(), request.quantity(), request.reorderLevel());
        return inventoryRepository.save(item);
    }
}
