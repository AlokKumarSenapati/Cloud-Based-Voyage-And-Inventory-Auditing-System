package com.cloudvoyage.api;

import java.time.LocalDateTime;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record VoyageRequest(
        @NotBlank String referenceNumber,
        @NotBlank String origin,
        @NotBlank String destination,
        @NotBlank String vessel,
        @NotNull LocalDateTime eta,
        @NotBlank String status,
        @Min(0) @Max(100) int progress) {
}
