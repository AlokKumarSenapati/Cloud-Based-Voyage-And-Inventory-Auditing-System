package com.cloudvoyage.api;

public record LoginRequest(
        String usernameOrEmail,
        String password,
        String captchaId,
        String captchaAnswer
) {}

