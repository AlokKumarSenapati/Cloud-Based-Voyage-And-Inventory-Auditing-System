package com.cloudvoyage.api;

import java.net.URI;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/voyages")
public class VoyageController {

    private final VoyageRepository voyageRepository;

    public VoyageController(VoyageRepository voyageRepository) {
        this.voyageRepository = voyageRepository;
    }

    @GetMapping
    public List<Voyage> findAll() {
        return voyageRepository.findAllByOrderByEtaAsc();
    }

    @GetMapping("/{id}")
    public Voyage findById(@PathVariable Long id) {
        return voyageRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Voyage not found"));
    }

    @PostMapping
    public ResponseEntity<Voyage> create(@Valid @RequestBody VoyageRequest request) {
        Voyage voyage = new Voyage(
                request.referenceNumber(), request.origin(), request.destination(), request.vessel(),
                request.eta(), request.status(), request.progress());
        Voyage saved = voyageRepository.save(voyage);
        return ResponseEntity.created(URI.create("/api/voyages/" + saved.getId())).body(saved);
    }

    @PutMapping("/{id}")
    public Voyage update(@PathVariable Long id, @Valid @RequestBody VoyageRequest request) {
        Voyage voyage = findById(id);
        voyage.update(
                request.referenceNumber(), request.origin(), request.destination(), request.vessel(),
                request.eta(), request.status(), request.progress());
        return voyageRepository.save(voyage);
    }
}
