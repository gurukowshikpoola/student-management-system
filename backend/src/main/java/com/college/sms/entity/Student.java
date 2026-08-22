package com.college.sms.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

/**
 * Maps to the STUDENTS table in the Oracle database.
 * Holds personal + academic details of a student.
 */
@Entity
@Table(name = "STUDENTS")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "students_seq_gen")
    @SequenceGenerator(name = "students_seq_gen", sequenceName = "STUDENTS_SEQ", allocationSize = 1)
    @Column(name = "ID")
    private Long id;

    // -------- Personal details --------
    @Column(name = "ROLL_NUMBER", nullable = false, unique = true, length = 20)
    private String rollNumber;

    @Column(name = "STUDENT_NAME", nullable = false, length = 100)
    private String studentName;

    /** CSE, ECE, EEE, MECH, CIVIL, IT, CSD, CSAI, CSM, CSC */
    @Column(name = "DEPARTMENT", nullable = false, length = 20)
    private String department;

    /** 1st Year / 2nd Year / 3rd Year / 4th Year */
    @Column(name = "ACADEMIC_YEAR", nullable = false, length = 20)
    private String academicYear;

    /** Regular / Lateral Entry */
    @Column(name = "ADMISSION_TYPE", nullable = false, length = 20)
    private String admissionType;

    @Column(name = "GENDER", nullable = false, length = 10)
    private String gender;

    @Column(name = "DATE_OF_BIRTH")
    private LocalDate dateOfBirth;

    @Column(name = "MOBILE_NUMBER", length = 15)
    private String mobileNumber;

    @Column(name = "EMAIL", length = 100)
    private String email;

    // -------- Prior academics --------
    @Column(name = "SSC_PERCENTAGE")
    private Double sscPercentage;

    @Column(name = "INTER_PERCENTAGE")
    private Double interPercentage;

    @Column(name = "DIPLOMA_PERCENTAGE")
    private Double diplomaPercentage;

    // -------- Semester SGPAs --------
    @Column(name = "SEM1_SGPA") private Double sem1Sgpa;
    @Column(name = "SEM2_SGPA") private Double sem2Sgpa;
    @Column(name = "SEM3_SGPA") private Double sem3Sgpa;
    @Column(name = "SEM4_SGPA") private Double sem4Sgpa;
    @Column(name = "SEM5_SGPA") private Double sem5Sgpa;
    @Column(name = "SEM6_SGPA") private Double sem6Sgpa;
    @Column(name = "SEM7_SGPA") private Double sem7Sgpa;
    @Column(name = "SEM8_SGPA") private Double sem8Sgpa;

    @Column(name = "FINAL_CGPA")
    private Double finalCgpa;
}
