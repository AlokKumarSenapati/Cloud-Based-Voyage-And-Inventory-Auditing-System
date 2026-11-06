package com.cloudvoyage.api;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/blockchain")
public class BlockchainAuditController {

    private final BlockchainAuditRecordRepository blockchainRepository;

    public BlockchainAuditController(BlockchainAuditRecordRepository blockchainRepository) {
        this.blockchainRepository = blockchainRepository;
    }

    @GetMapping("/records/{auditCode}")
    public BlockchainAuditRecord getByAuditCode(@PathVariable String auditCode) {
        return blockchainRepository.findByAuditCode(auditCode)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Blockchain record not found for audit: " + auditCode));
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verifyHash(@RequestBody Map<String, String> payload) {
        String hash = payload.get("hash");
        if (hash == null || hash.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Hash is required"));
        }

        return blockchainRepository.findByReportHash(hash)
                .map(record -> ResponseEntity.ok(Map.of(
                        "verified", true,
                        "auditCode", record.getAuditCode(),
                        "txHash", record.getTxHash(),
                        "network", record.getNetwork(),
                        "contractAddress", record.getContractAddress(),
                        "registeredAt", record.getRegisteredAt().toString()
                )))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of(
                        "verified", false,
                        "message", "No matching audit record found on the blockchain."
                )));
    }
}

