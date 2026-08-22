package com.college.sms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping({"/", "/login"})
    public String loginPage() {
        return "login";
    }

    @GetMapping("/dashboard")
    public String dashboardPage() {
        return "dashboard";
    }

    @GetMapping("/students/add")
    public String addStudentPage() {
        return "add-student";
    }

    @GetMapping("/students/view")
    public String viewStudentsPage() {
        return "view-students";
    }

    @GetMapping("/students/update")
    public String updateStudentPage() {
        return "update-student";
    }

    @GetMapping("/students/delete")
    public String deleteStudentPage() {
        return "delete-student";
    }
}
