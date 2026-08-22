package com.college.sms.controller;

import com.college.sms.dto.LoginRequest;
import com.college.sms.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * REST endpoints for admin authentication.
 */
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminService adminService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest req) {
        boolean ok = adminService.validateLogin(req.getAdminId(), req.getPassword());
        if (ok) {
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Login successful."));
        }
        return ResponseEntity.status(401).body(Map.of(
                "success", false,
                "message", "Invalid Admin ID or Password."));
    }
}
