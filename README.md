# University Registrar System in Oracle PL/SQL

This project implements a simplified **university registrar system** using **Oracle SQL and PL/SQL**.  
It models departments, students, courses, and enrollments, and provides stored procedures and functions to:

- Add students
- Enroll students in courses
- Assign grades
- Compute course grade averages
- Display detailed course enrollment information

The project was developed as part of a database application development course using Oracle.

---

## Features

### Core Schema

The database consists of four main tables:

- **DEPARTMENTS**  
  - `departmentID` (PK)  
  - `departmentName`

- **STUDENTS**  
  - `studentID` (PK)  
  - `firstName`  
  - `lastName`  
  - `email`  
  - `departmentID` (FK → DEPARTMENTS)

- **COURSES**  
  - `courseID` (PK)  
  - `courseName`  
  - `credits`  
  - `departmentID` (FK → DEPARTMENTS)

- **ENROLLMENTS**  
  - `enrollmentID` (PK)  
  - `studentID` (FK → STUDENTS)  
  - `courseID` (FK → COURSES)  
  - `grade`  
  - (D2) Unique constraint to prevent duplicate student–course enrollments

Sequences are used to auto-generate primary keys for each table.

---

## PL/SQL Objects

### Helper Functions

- `find_department_id(dept VARCHAR2) RETURN INT`  
  Returns the ID of a department by its name (e.g., `'IS'`, `'CS'`, `'MATH'`, `'BIO'`).

- `find_student_id_withname(s_fname VARCHAR2, s_lname VARCHAR2) RETURN INT`  
  Returns the student ID based on first and last name.

- `find_studentid_with_name_email(s_fname VARCHAR2, s_lname VARCHAR2, e_mail VARCHAR2) RETURN INT`  
  (D2) Returns the student ID using first name, last name, and email.

- `find_course_id_withname(c_name VARCHAR2) RETURN INT`  
  Returns the course ID based on course name (e.g., `'IS 410'`, `'MATH 100'`).

- `course_average(c_id INT) RETURN NUMBER`  
  (D2) Computes the average grade point of all graded enrollments in a given course using a 4.0 scale (A=4, B=3, C=2, D=1, F=0). Prints a message if no graded students are found.

### Procedures

- `add_student(fname, lname, e_mail, dept)`  
  Inserts a new student into the STUDENTS table for the given department name.  
  - Validates the department via `find_department_id`.  
  - Prints an error message if the department does not exist.

- `enroll_student(s_id, c_id)`  
  Inserts a new row into ENROLLMENTS for a given student and course.  
  - Validates that both IDs are positive.  
  - (D2) Prints success or error messages via `DBMS_OUTPUT`.

- `assign_grade(s_id, c_id, grade)`  
  (D2) Assigns or updates a letter grade (A/B/C/D/F) for the given student and course in ENROLLMENTS.  
  - Normalizes the grade to uppercase.  
  - Validates that the grade is one of A, B, C, D, F.  
  - Prints a message if no matching enrollment row is found.

- `students_in_course(c_id)`  
  (D2) Displays:
  - Course details (name, credits, department)
  - List of enrolled students (name, email, department)
  - Distribution of enrolled students by department

  Output is printed using `DBMS_OUTPUT.PUT_LINE` with multiple cursors.

---

## Anonymous Blocks (Scenarios / Demo)

Each script includes an anonymous PL/SQL block that demonstrates the system behavior:

### Deliverable 1 Scenario

The first script:

- Inserts sample departments and courses.
- Uses `add_student` to add multiple sample students.
- Uses `enroll_student` to:
  - Enroll one student (Mary Myrtle) into multiple MATH courses.
  - Enroll Mark in all MATH courses.
  - Enroll Collin in all IS courses.
  - Enroll Abel in all CMSC courses.
- Prints:
  - All students in the STUDENTS table.
  - All students who are enrolled in **CMSC** or **IS** courses, with course names.

### Deliverable 2 Scenario (Extended)

The second script extends Deliverable 1 and additionally:

- Enrolls multiple students into various IS, MATH, CMSC, and BIO courses.
- Assigns grades to several enrollments using `assign_grade`.
- Calls `students_in_course` for `'MATH 100'` to display detailed course-level information.
- Uses a VARRAY of course names and calls `course_average` for each:
  - `MATH 100`, `IS 610`, `IS 620`, `IS 700`, `BIO 602`, `CMSC 202`
- Prints the average grade for each course where graded students exist.

At the end of the block, changes are committed with `COMMIT`.

---

## Project Structure

You can structure the repository like this:

```text
.
├── D1_Patel_Script_Project.sql   # Deliverable 1: basic registrar system + enrollments demo
├── D2_Patel_Script_Project.sql   # Deliverable 2: extended system with grades, averages, and reports
└── README.md                     # Project documentation
# Student-Enrollment-System-PL-SQL-
A complete Oracle PL/SQL project that simulates a university registrar system. Implements database schema creation, student and course management, enrollment workflows, grade assignment, course-average calculations, and detailed course-level reporting using procedures, functions, and DBMS_OUTPUT.
