package com.cloudvoyage.api;

import java.time.LocalDate;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record InventoryAuditRequest(
        @NotBlank String auditCode,
        @NotBlank String location,
        @NotBlank String auditor,
        @NotNull LocalDate auditDate,
        int variance,
        @NotBlank String status) {
}
