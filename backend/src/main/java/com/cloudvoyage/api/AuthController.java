package com.cloudvoyage.api;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    private final UserRepository userRepository;
    private final SecureRandom random = new SecureRandom();

    // Store active captchas with creation timestamp (expires in 10 minutes)
    private record CaptchaItem(String expectedAnswer, Instant expiresAt) {}
    private final Map<String, CaptchaItem> captchaStore = new ConcurrentHashMap<>();

    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

    public AuthController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Generate a new Captcha challenge with alphanumeric visual code and mathematical verification.
     */
    @GetMapping("/captcha")
    public CaptchaResponse generateCaptcha() {
        // Clean up expired items periodically
        Instant now = Instant.now();
        captchaStore.entrySet().removeIf(e -> e.getValue().expiresAt.isBefore(now));

        String captchaId = UUID.randomUUID().toString();
        
        // Randomly generate either an alphanumeric code or a simple math challenge
        boolean isMath = random.nextBoolean();
        String question;
        String answer;
        String visualCode;

        if (isMath) {
            int a = 10 + random.nextInt(40);
            int b = 3 + random.nextInt(20);
            question = "Calculate: " + a + " + " + b;
            answer = String.valueOf(a + b);
            visualCode = a + " + " + b + " = ?";
        } else {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 5; i++) {
                sb.append(CHARS.charAt(random.nextInt(CHARS.length())));
            }
            visualCode = sb.toString();
            question = "Type the 5 characters shown below";
            answer = visualCode;
        }

        captchaStore.put(captchaId, new CaptchaItem(answer.trim().toUpperCase(), now.plusSeconds(600)));
        return new CaptchaResponse(captchaId, question, visualCode);
    }

    /**
     * User authentication endpoint (Login)
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        // 1. Verify Captcha
        if (request.captchaId() != null && !request.captchaId().isBlank()) {
            CaptchaItem item = captchaStore.remove(request.captchaId());
            if (item == null || item.expiresAt.isBefore(Instant.now())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Captcha expired. Please click refresh.");
            }
            if (request.captchaAnswer() == null || !item.expectedAnswer().equalsIgnoreCase(request.captchaAnswer().trim())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Captcha answer. Please try again.");
            }
        }

        // 2. Locate user by username or email
        String identifier = request.usernameOrEmail() != null ? request.usernameOrEmail().trim() : "";
        Optional<User> userOpt = userRepository.findByUsername(identifier);
        if (userOpt.isEmpty()) {
            userOpt = userRepository.findByEmail(identifier);
        }

        if (userOpt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid username or email address.");
        }

        User user = userOpt.get();

        // 3. Password check (accept plain or match)
        if (!user.getPasswordHash().equals(request.password())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Incorrect password. Please try again.");
        }

        String sessionToken = "cv-token-" + UUID.randomUUID();
        return ResponseEntity.ok(new AuthResponse(
                true,
                "Authentication successful. Welcome back " + user.getFullName() + "!",
                sessionToken,
                UserResponse.from(user)
        ));
    }

    /**
     * User registration endpoint (Sign Up)
     */
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest request) {
        // 1. Verify Captcha
        if (request.captchaId() != null && !request.captchaId().isBlank()) {
            CaptchaItem item = captchaStore.remove(request.captchaId());
            if (item == null || item.expiresAt.isBefore(Instant.now())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Captcha expired. Please click refresh.");
            }
            if (request.captchaAnswer() == null || !item.expectedAnswer().equalsIgnoreCase(request.captchaAnswer().trim())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Captcha answer. Please try again.");
            }
        }

        // 2. Validate inputs
        if (request.username() == null || request.username().trim().length() < 3) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Username must be at least 3 characters.");
        }
        if (request.email() == null || !request.email().contains("@")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Please provide a valid email address.");
        }
        if (request.password() == null || request.password().length() < 6) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password must be at least 6 characters.");
        }

        String username = request.username().trim();
        String email = request.email().trim().toLowerCase();

        if (userRepository.existsByUsername(username)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Username '" + username + "' is already taken.");
        }
        if (userRepository.existsByEmail(email)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "An account with email '" + email + "' already exists.");
        }

        String role = (request.role() != null && !request.role().isBlank()) ? request.role().trim() : "User";
        String fullName = (request.fullName() != null && !request.fullName().isBlank()) ? request.fullName().trim() : username;

        User newUser = new User(username, fullName, email, request.password(), role);
        User savedUser = userRepository.save(newUser);

        String sessionToken = "cv-token-" + UUID.randomUUID();
        return ResponseEntity.status(HttpStatus.CREATED).body(new AuthResponse(
                true,
                "Account created successfully as " + role + ". Welcome to Cloud Voyage!",
                sessionToken,
                UserResponse.from(savedUser)
        ));
    }
}

