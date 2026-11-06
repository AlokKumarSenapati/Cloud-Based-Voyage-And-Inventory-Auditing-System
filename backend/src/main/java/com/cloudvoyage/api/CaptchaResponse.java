package com.cloudvoyage.api;

public record CaptchaResponse(
        String captchaId,
        String question,
        String visualCode
) {}

