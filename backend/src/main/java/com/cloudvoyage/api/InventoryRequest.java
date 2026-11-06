package com.cloudvoyage.api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.PositiveOrZero;

public record InventoryRequest(
        @NotBlank String sku,
        @NotBlank String itemName,
        @NotBlank String location,
        @PositiveOrZero int quantity,
        @PositiveOrZero int reorderLevel) {
}
