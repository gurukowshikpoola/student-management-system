package com.college.sms.service;

import com.college.sms.repository.AdminRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * Business logic for admin authentication.
 */
@Service
@RequiredArgsConstructor
public class AdminService {

    private final AdminRepository adminRepository;

    /**
     * @return true if the given credentials match a row in ADMINS.
     */
    public boolean validateLogin(String adminId, String password) {
        if (adminId == null || password == null) return false;
        return adminRepository
                .findByAdminIdAndPassword(adminId.trim(), password)
                .isPresent();
    }
}
