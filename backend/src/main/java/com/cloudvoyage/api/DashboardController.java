package com.cloudvoyage.api;

import java.time.YearMonth;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class DashboardController {

    private final VoyageRepository voyageRepository;
    private final InventoryRepository inventoryRepository;
    private final InventoryAuditRepository auditRepository;

    public DashboardController(VoyageRepository voyageRepository, InventoryRepository inventoryRepository,
                               InventoryAuditRepository auditRepository) {
        this.voyageRepository = voyageRepository;
        this.inventoryRepository = inventoryRepository;
        this.auditRepository = auditRepository;
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP", "service", "cloud-voyage-api");
    }

    @GetMapping("/dashboard")
    public DashboardSummary dashboard() {
        List<Voyage> voyages = voyageRepository.findAllByOrderByEtaAsc();
        List<InventoryItem> inventory = inventoryRepository.findAllByOrderByItemNameAsc();
        List<InventoryAudit> audits = auditRepository.findAllByOrderByAuditDateDesc();
        YearMonth currentMonth = YearMonth.now();

        long activeVoyages = voyages.stream()
                .filter(v -> !"Completed".equalsIgnoreCase(v.getStatus()))
                .count();
        int inventoryUnits = inventory.stream().mapToInt(InventoryItem::getQuantity).sum();
        long lowStockItems = inventory.stream()
                .filter(item -> item.getQuantity() <= item.getReorderLevel())
                .count();
        long auditsThisMonth = audits.stream()
                .filter(audit -> YearMonth.from(audit.getAuditDate()).equals(currentMonth))
                .count();
        long openDiscrepancies = audits.stream()
                .filter(audit -> audit.getVariance() != 0)
                .count();

        return new DashboardSummary(
                activeVoyages, inventoryUnits, lowStockItems, auditsThisMonth, openDiscrepancies,
                voyages.stream().limit(5).toList(), audits.stream().limit(5).toList());
    }
}
