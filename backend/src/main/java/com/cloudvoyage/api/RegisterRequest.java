package com.cloudvoyage.api;

public record RegisterRequest(
        String username,
        String fullName,
        String email,
        String password,
        String role,
        String captchaId,
        String captchaAnswer
) {}

