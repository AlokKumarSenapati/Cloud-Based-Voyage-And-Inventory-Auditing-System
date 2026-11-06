package com.cloudvoyage.api;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VoyageCargoRepository extends JpaRepository<VoyageCargo, Long> {

    List<VoyageCargo> findByVoyageReference(String voyageReference);
}

