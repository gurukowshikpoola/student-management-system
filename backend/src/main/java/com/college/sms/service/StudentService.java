package com.college.sms.service;

import com.college.sms.entity.Student;
import com.college.sms.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Business logic for student CRUD + rule enforcement.
 */
@Service
@RequiredArgsConstructor
public class StudentService {

    private final StudentRepository studentRepository;

    // ---- Create ----
    public Student addStudent(Student s) {
        if (studentRepository.existsByRollNumber(s.getRollNumber())) {
            throw new IllegalArgumentException(
                    "Roll Number '" + s.getRollNumber() + "' already exists.");
        }
        applyAdmissionRules(s);
        return studentRepository.save(s);
    }

    // ---- Read ----
    public List<Student> getByDepartment(String department) {
        return studentRepository.findByDepartment(department);
    }

    public Student getByRollNumber(String rollNumber) {
        return studentRepository.findByRollNumber(rollNumber)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No student found with Roll Number: " + rollNumber));
    }

    public List<Student> search(String query) {
        if (query == null) query = "";
        return studentRepository
                .findByRollNumberContainingIgnoreCaseOrStudentNameContainingIgnoreCase(query, query);
    }

    // ---- Update (Roll Number and Department are immutable) ----
    public Student updateStudent(String rollNumber, Student updates) {
        Student existing = getByRollNumber(rollNumber);

        existing.setStudentName(updates.getStudentName());
        existing.setAcademicYear(updates.getAcademicYear());
        existing.setAdmissionType(updates.getAdmissionType());
        existing.setGender(updates.getGender());
        existing.setDateOfBirth(updates.getDateOfBirth());
        existing.setMobileNumber(updates.getMobileNumber());
        existing.setEmail(updates.getEmail());

        existing.setSscPercentage(updates.getSscPercentage());
        existing.setInterPercentage(updates.getInterPercentage());
        existing.setDiplomaPercentage(updates.getDiplomaPercentage());

        existing.setSem1Sgpa(updates.getSem1Sgpa());
        existing.setSem2Sgpa(updates.getSem2Sgpa());
        existing.setSem3Sgpa(updates.getSem3Sgpa());
        existing.setSem4Sgpa(updates.getSem4Sgpa());
        existing.setSem5Sgpa(updates.getSem5Sgpa());
        existing.setSem6Sgpa(updates.getSem6Sgpa());
        existing.setSem7Sgpa(updates.getSem7Sgpa());
        existing.setSem8Sgpa(updates.getSem8Sgpa());
        existing.setFinalCgpa(updates.getFinalCgpa());

        applyAdmissionRules(existing);
        return studentRepository.save(existing);
    }

    // ---- Delete ----
    @Transactional
    public void deleteByRollNumber(String rollNumber) {
        Student existing = getByRollNumber(rollNumber);
        studentRepository.delete(existing);
    }

    // ------------------------------------------------------------------
    // Business rules
    //   Regular      -> 1st Year only, requires SSC% and Intermediate%
    //   Lateral Entry-> 2nd Year only, requires Diploma%, no Intermediate%
    // ------------------------------------------------------------------
    private void applyAdmissionRules(Student s) {
        String type = s.getAdmissionType() == null ? "" : s.getAdmissionType().trim();

        if ("Regular".equalsIgnoreCase(type)) {
            if (!"1st Year".equalsIgnoreCase(s.getAcademicYear())) {
                throw new IllegalArgumentException(
                        "Regular students can only be admitted into 1st Year.");
            }
            if (s.getSscPercentage() == null || s.getInterPercentage() == null) {
                throw new IllegalArgumentException(
                        "SSC and Intermediate percentages are required for Regular admission.");
            }
            s.setDiplomaPercentage(null); // not applicable
        } else if ("Lateral Entry".equalsIgnoreCase(type)) {
            if (!"2nd Year".equalsIgnoreCase(s.getAcademicYear())) {
                throw new IllegalArgumentException(
                        "Lateral Entry students can only be admitted into 2nd Year.");
            }
            if (s.getDiplomaPercentage() == null) {
                throw new IllegalArgumentException(
                        "Diploma percentage is required for Lateral Entry admission.");
            }
            s.setInterPercentage(null); // not applicable
            s.setSem1Sgpa(null);        // no 1st-year data
            s.setSem2Sgpa(null);
        } else {
            throw new IllegalArgumentException(
                    "Admission Type must be 'Regular' or 'Lateral Entry'.");
        }
    }
}
