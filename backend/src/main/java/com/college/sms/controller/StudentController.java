package com.college.sms.controller;

import com.college.sms.entity.Student;
import com.college.sms.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * REST endpoints for student CRUD.
 */
@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;

    /** Add a new student. */
    @PostMapping
    public ResponseEntity<?> add(@RequestBody Student student) {
        try {
            Student saved = studentService.addStudent(student);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Student Added Successfully.",
                    "student", saved));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", e.getMessage()));
        }
    }

    /** List all students in a department. */
    @GetMapping("/department/{department}")
    public List<Student> byDepartment(@PathVariable String department) {
        return studentService.getByDepartment(department);
    }

    /** Fetch one student by roll number. */
    @GetMapping("/{rollNumber}")
    public ResponseEntity<?> byRoll(@PathVariable String rollNumber) {
        try {
            return ResponseEntity.ok(studentService.getByRollNumber(rollNumber));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of(
                    "success", false, "message", e.getMessage()));
        }
    }

    /** Search by roll number OR name (contains, case-insensitive). */
    @GetMapping("/search")
    public List<Student> search(@RequestParam(defaultValue = "") String query) {
        return studentService.search(query);
    }

    /** Update a student (roll number & department cannot be changed). */
    @PutMapping("/{rollNumber}")
    public ResponseEntity<?> update(@PathVariable String rollNumber,
                                    @RequestBody Student updates) {
        try {
            Student saved = studentService.updateStudent(rollNumber, updates);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Student Updated Successfully.",
                    "student", saved));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false, "message", e.getMessage()));
        }
    }

    /** Delete a student by roll number. */
    @DeleteMapping("/{rollNumber}")
    public ResponseEntity<?> delete(@PathVariable String rollNumber) {
        try {
            studentService.deleteByRollNumber(rollNumber);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Student Successfully Deleted."));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(404).body(Map.of(
                    "success", false, "message", e.getMessage()));
        }
    }
}
