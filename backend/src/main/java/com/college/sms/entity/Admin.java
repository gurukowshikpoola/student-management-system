package com.college.sms.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Maps to the ADMINS table in the Oracle database.
 */
@Entity
@Table(name = "ADMINS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Admin {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "admins_seq_gen")
    @SequenceGenerator(name = "admins_seq_gen", sequenceName = "ADMINS_SEQ", allocationSize = 1)
    @Column(name = "ID")
    private Long id;

    @Column(name = "ADMIN_ID", nullable = false, unique = true, length = 50)
    private String adminId;

    @Column(name = "PASSWORD", nullable = false, length = 100)
    private String password;
}
