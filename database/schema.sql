-- ============================================================
-- Student Management System - PostgreSQL Database Schema
-- ============================================================

-- Drop tables if they exist
DROP TABLE IF EXISTS STUDENTS CASCADE;
DROP TABLE IF EXISTS ADMINS CASCADE;

-- Drop sequences if they exist
DROP SEQUENCE IF EXISTS ADMINS_SEQ CASCADE;
DROP SEQUENCE IF EXISTS STUDENTS_SEQ CASCADE;


-- ============================================================
-- ADMINS
-- ============================================================

CREATE TABLE ADMINS (
    ID          INTEGER PRIMARY KEY,
    ADMIN_ID    VARCHAR(50) NOT NULL UNIQUE,
    PASSWORD    VARCHAR(100) NOT NULL
);

CREATE SEQUENCE ADMINS_SEQ
    START WITH 1
    INCREMENT BY 1;

-- Default admin
-- Admin ID: admin
-- Password: admin123

INSERT INTO ADMINS (ID, ADMIN_ID, PASSWORD)
VALUES (NEXTVAL('ADMINS_SEQ'), 'admin', 'admin123');


-- ============================================================
-- STUDENTS
-- ============================================================

CREATE TABLE STUDENTS (
    ID                     INTEGER PRIMARY KEY,
    ROLL_NUMBER            VARCHAR(20) NOT NULL UNIQUE,
    STUDENT_NAME           VARCHAR(100) NOT NULL,
    DEPARTMENT             VARCHAR(20) NOT NULL,
    ACADEMIC_YEAR          VARCHAR(20) NOT NULL,
    ADMISSION_TYPE         VARCHAR(20) NOT NULL,
    GENDER                 VARCHAR(10) NOT NULL,
    DATE_OF_BIRTH          DATE,
    MOBILE_NUMBER          VARCHAR(15),
    EMAIL                  VARCHAR(100),

    SSC_PERCENTAGE         NUMERIC(5,2),
    INTER_PERCENTAGE       NUMERIC(5,2),
    DIPLOMA_PERCENTAGE     NUMERIC(5,2),

    SEM1_SGPA              NUMERIC(4,2),
    SEM2_SGPA              NUMERIC(4,2),
    SEM3_SGPA              NUMERIC(4,2),
    SEM4_SGPA              NUMERIC(4,2),
    SEM5_SGPA              NUMERIC(4,2),
    SEM6_SGPA              NUMERIC(4,2),
    SEM7_SGPA              NUMERIC(4,2),
    SEM8_SGPA              NUMERIC(4,2),
    FINAL_CGPA              NUMERIC(4,2)
);

CREATE SEQUENCE STUDENTS_SEQ
    START WITH 1
    INCREMENT BY 1;


-- ============================================================
-- END
-- ============================================================