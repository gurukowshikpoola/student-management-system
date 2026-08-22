package com.college.sms.dto;

import lombok.Data;

/** Payload for POST /api/admin/login */
@Data
public class LoginRequest {
    private String adminId;
    private String password;
}
