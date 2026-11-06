package com.cloudvoyage.api;

public record AuthResponse(
        boolean success,
        String message,
        String token,
        UserResponse user
) {}

