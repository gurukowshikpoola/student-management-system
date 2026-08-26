package com.college.sms;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Entry point for the Student Management System Spring Boot application.
 */
@SpringBootApplication
public class SmsApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(SmsApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(SmsApplication.class, args);
    }
}