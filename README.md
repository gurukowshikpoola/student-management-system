# Student Management System (SMS)

A full-stack college mini project.

- **Backend:** Spring Boot 3 (Java 17), Spring Web, Spring Data JPA, Oracle JDBC
- **Frontend:** JSP pages rendered by Spring MVC with Bootstrap 5 and custom CSS
- **Database:** Oracle Database
- **ORM:** Hibernate (via Spring Data JPA)

## Project Structure

```
sms-project/
├── backend/               Spring Boot application
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/college/sms/
│       │   ├── SmsApplication.java
│       │   ├── config/          CORS config
│       │   ├── entity/          JPA entities (Admin, Student)
│       │   ├── repository/      Spring Data JPA repositories
│       │   ├── service/         Business logic
│       │   ├── controller/      REST APIs + JSP page controllers
│       │   └── dto/             Login request DTO
│       ├── resources/
│       │   ├── application.properties
│       │   └── static/css/style.css
│       └── webapp/WEB-INF/views/
│           ├── login.jsp
│           ├── dashboard.jsp
│           ├── add-student.jsp
│           ├── view-students.jsp
│           ├── update-student.jsp
│           └── delete-student.jsp
├── database/
│   └── schema.sql         Oracle DDL + seed admin
└── README.md
```

## Setup

### 1. Oracle Database

Run `database/schema.sql` in SQL*Plus / SQL Developer as a user (e.g. `sms_user`).
This creates the `ADMINS` and `STUDENTS` tables and inserts a default admin:

- **Admin ID:** `admin`
- **Password:** `admin123`

### 2. Backend (Spring Boot)

Edit `backend/src/main/resources/application.properties` and set:

```
spring.datasource.url=jdbc:oracle:thin:@localhost:1521:XE
spring.datasource.username=sms_user
spring.datasource.password=your_password
```

Then run:

```
cd backend
mvn spring-boot:run
```

Backend starts on `http://localhost:8080`.

### 3. Frontend

The application now serves JSP pages from the Spring Boot backend at:

- `http://localhost:8080/login`
- `http://localhost:8080/dashboard`
- `http://localhost:8080/students/add`
- `http://localhost:8080/students/view`
- `http://localhost:8080/students/update`
- `http://localhost:8080/students/delete`

The UI calls the backend REST API at `http://localhost:8080/api/...` (CORS is enabled).

## REST API summary

| Method | Endpoint | Purpose |
|-------|----------|---------|
| POST | `/api/admin/login` | Admin login |
| POST | `/api/students` | Add student |
| GET  | `/api/students/department/{dept}` | List by department |
| GET  | `/api/students/{rollNo}` | Get by roll number |
| GET  | `/api/students/search?query=` | Search by roll or name |
| PUT  | `/api/students/{rollNo}` | Update student |
| DELETE | `/api/students/{rollNo}` | Delete student |

## Business Rules

- **Regular** admission → 1st Year only, requires SSC % and Intermediate %.
- **Lateral Entry** → 2nd Year only, requires Diploma %. No Intermediate, no 1st year CGPA.
- Roll Number is unique.
- Departments: CSE, ECE, EEE, MECH, CIVIL, IT, CSD, CSAI, CSM, CSC.
