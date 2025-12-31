# Student Enrollment System (PL/SQL)

## Overview
This project implements a database-driven Student Enrollment System designed to manage students, courses, departments, and enrollments using Oracle SQL and PL/SQL. The system focuses on backend logic, data integrity, and transactional reliability to support core academic operations.

The project demonstrates how structured database design and procedural logic can support real-world operational workflows and decision making.

## Problem Context
Academic institutions manage complex enrollment processes involving students, courses, prerequisites, grades, and departmental structures. Without a well-designed backend system, these processes can become error-prone, inefficient, and difficult to scale.

This project models those challenges and implements a centralized enrollment system that enforces business rules directly at the database level.

## System Design & Approach
- Designed relational schemas for students, courses, departments, and enrollments
- Used sequences for primary key generation to ensure scalability
- Implemented PL/SQL procedures and functions to manage enrollments and records
- Applied constraints and exception handling to enforce business rules
- Ensured transactional consistency across all operations

## Tools & Technologies
- Oracle SQL  
- PL/SQL  
- Relational database design  
- Stored procedures, functions, and exception handling

## Key Capabilities
- Add and manage student records
- Enroll students into courses using procedural logic
- Enforce data integrity and business constraints
- Support query-based reporting and analysis
- Provide a reliable backend for academic workflows

## Notes & Future Improvements
- Extend the schema to support waitlists and prerequisites
- Add reporting views for enrollment analytics
- Integrate a frontend interface for end-user interaction
