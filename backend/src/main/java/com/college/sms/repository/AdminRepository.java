package com.college.sms.repository;

import com.college.sms.entity.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * Spring Data JPA repository for Admin entity.
 */
public interface AdminRepository extends JpaRepository<Admin, Long> {

    /** Used during admin login. */
    Optional<Admin> findByAdminIdAndPassword(String adminId, String password);
}
