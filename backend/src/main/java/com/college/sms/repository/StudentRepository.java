package com.college.sms.repository;

import com.college.sms.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data JPA repository for Student entity.
 */
public interface StudentRepository extends JpaRepository<Student, Long> {

    Optional<Student> findByRollNumber(String rollNumber);

    boolean existsByRollNumber(String rollNumber);

    List<Student> findByDepartment(String department);

    /** Search by roll number OR name (case-insensitive contains). */
    List<Student> findByRollNumberContainingIgnoreCaseOrStudentNameContainingIgnoreCase(
            String rollNumber, String studentName);

    void deleteByRollNumber(String rollNumber);
}
