package com.cloudvoyage.api;

import java.util.List;

public record DashboardSummary(
        long activeVoyages,
        int inventoryUnits,
        long lowStockItems,
        long auditsThisMonth,
        long openDiscrepancies,
        List<Voyage> voyages,
        List<InventoryAudit> recentAudits) {
}
