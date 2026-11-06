package com.cloudvoyage.api;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuditDetailRepository extends JpaRepository<AuditDetail, Long> {

    List<AuditDetail> findByAuditCode(String auditCode);
}

