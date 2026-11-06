package com.cloudvoyage.api;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface VoyageRepository extends JpaRepository<Voyage, Long> {
    List<Voyage> findAllByOrderByEtaAsc();
}
