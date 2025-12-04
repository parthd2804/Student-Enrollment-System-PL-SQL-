--drop all tables
drop table enrollments;
drop table courses;
drop table students;
drop table departments;

--drop all sequence
drop sequence seq_students;
drop sequence seq_courses;
drop sequence seq_departments;
drop sequence seq_enrollments;

-- create table departments
create table departments(
departmentID int primary key,
departmentName varchar(20)
);

--create table students
create table students (
studentID int primary key,
firstName varchar(30),
lastName varchar(30),
email varchar(80),
departmentID int,
foreign key (departmentID) references departments(departmentID)
);

--create table courses
create table courses (
courseID int primary key,
courseName varchar(50),
credits int,
departmentID int,
foreign key (departmentID) references departments(departmentID)
);

--create table enrollments
create table enrollments (
enrollmentID int primary key, 
studentID int,
courseID int,
grade varchar(10),
foreign key (studentID) references students(studentID),
foreign key (courseID) references courses(courseID)
);


--create sequences 
create sequence seq_students start with 1 increment by 1;
create sequence seq_departments start with 1 increment by 1;
create sequence seq_enrollments start with 1 increment by 1;
create sequence seq_courses start with 1 increment by 1;

--insert into departments table
insert into departments values(seq_departments.nextval, 'IS');
insert into departments values(seq_departments.nextval, 'CS');
insert into departments values(seq_departments.nextval, 'MATH');
insert into departments values(seq_departments.nextval, 'BIO');

--insert into courses
insert into courses values(seq_courses.NEXTVAL, 'IS 410', 3, find_department_id('IS'));
insert into courses values(seq_courses.NEXTVAL, 'IS 420', 3, find_department_id('IS'));
insert into courses values(seq_courses.NEXTVAL, 'IS 436', 3, find_department_id('IS'));
insert into courses values(seq_courses.NEXTVAL, 'CMSC 202', 3, find_department_id('CS'));
insert into courses values(seq_courses.NEXTVAL, 'CMSC 461', 3, find_department_id('CS'));
insert into courses values(seq_courses.NEXTVAL, 'CMSC 447', 3, find_department_id('CS'));
insert into courses values(seq_courses.NEXTVAL, 'MATH 100', 3, find_department_id('MATH'));
insert into courses values(seq_courses.NEXTVAL, 'MATH 151', 3, find_department_id('MATH'));
insert into courses values(seq_courses.NEXTVAL, 'MATH 300', 3, find_department_id('MATH'));
insert into courses values(seq_courses.NEXTVAL, 'IS 610', 3, find_department_id('IS'));
insert into courses values(seq_courses.NEXTVAL, 'IS 620', 3, find_department_id('IS'));
insert into courses values(seq_courses.NEXTVAL, 'IS 700', 2, find_department_id('IS'));
insert into courses values(seq_courses.NEXTVAL, 'CMSC 632', 3, find_department_id('CS'));
insert into courses values(seq_courses.NEXTVAL, 'CMSC 620', 3, find_department_id('CS'));
insert into courses values(seq_courses.NEXTVAL, 'CMSC 700', 2, find_department_id('CS'));
insert into courses values(seq_courses.NEXTVAL, 'BIO 202', 3, find_department_id('BIO'));
insert into courses values(seq_courses.NEXTVAL, 'BIO 402', 3, find_department_id('BIO'));
insert into courses values(seq_courses.NEXTVAL, 'BIO 602', 3, find_department_id('BIO'));
insert into courses values(seq_courses.NEXTVAL, 'BIO 700', 2, find_department_id('BIO'));

--create helper function find_department_id 
--input departmentname
--output departmentID
create or replace function find_department_id (dept varchar)
return int
IS
dept_id int;
begin
  select departmentID into dept_id from departments where departmentName= dept;
  return dept_id;
exception 
  when no_data_found then
  return -1;
end;
/

--create helper function find_student_id_withname
--input student firstname, lastname 
--output studentid

create or replace function find_student_id_withname(s_fname varchar, s_lname varchar) return int is
s_id int;
begin
	select studentID into s_id from students where firstName= s_fname AND lastName=s_lname;
	return s_id;
exception
	when no_data_found then
	return -1;
end;
/

--create helper function find_course_id_withname
--input course name
--output courseID

create or replace function find_course_id_withname(c_name varchar) return int is
c_id int;
begin
	select courseID into c_id from courses where courseName= c_name;
	return c_id;
exception
	when no_data_found then
	return -1;
end;	
/


--create procedure add_student
--input student first name, last name , email , department name
--Output inserting student into students table

create or replace procedure add_student(fname varchar,lname varchar, e_mail varchar, dept varchar) is
dept_id int;
begin
	dept_id:= find_department_id(dept); --getting dept id with use of helper
	
	if dept_id<0 then
		dbms_output.put_line('no department found with this name'); --exception error
	else
		--insertion into student table
		insert into students values (seq_students.NEXTVAL,fname,lname,e_mail,dept_id);
	end if;
exception 
    when others then
	dbms_output.put_line('sql error'||sqlerrm);
end;
/

--create enroll_student procedure
--input student id, course id
--output inserting into enrollments table
create or replace procedure enroll_student(s_id int, c_id int) is
begin 
	if s_id >0 AND c_id >0 then
		insert into enrollments values(seq_enrollments.NEXTVAL,s_id,c_id,'');
	else
		dbms_output.put_line('invalid student id or course id');
	end if;

exception 
    when others then
	dbms_output.put_line('sql error in procedure'||sqlerrm);
end;
/

--create annonymous block

set serveroutput on;
declare
s_id int;
c_id int;
-- cursor to print student table
cursor c_std is select * from students;
-- cursor to get courses from pattern
cursor c_courseid(course_pattern varchar) is select courseID from courses  where courseName LIKE course_pattern||'%';	
--cursor to select student and course name which are in CMSC or IS course
cursor c_output is select s.firstname, s.lastname, c.courseName from students s, courses c, enrollments e where s.studentid=e.studentid and c.courseid=e.courseID and (c.coursename Like 'CMSC%' OR c.coursename Like 'IS%');
begin

--inserting student with add_student procedure 
	begin 
		add_student('Collin','Cabobs','cabobs@gmail.com','IS');
	exception
		when others then
		dbms_output.put_line('error while adding collin'||sqlerrm);
	end;
	
	begin
		add_student('Isaac','Istiq','istiq@gmail.com','IS');
	exception
		when others then
		dbms_output.put_line('error while adding Isaac'||sqlerrm);
	end;
 
    begin
		add_student('Abel','Apron','apron@gmail.com','CS');
	exception
		when others then
		dbms_output.put_line('error while adding Abel'||sqlerrm);
	end;
	
	begin
		add_student('Ian','Iansson','iansson@gmail.com','CS');
	exception
		when others then
		dbms_output.put_line('error while adding Ian'||sqlerrm);
	end;
	
	begin
		add_student('Dick', 'Disney', 'disney@gmail.com', 'IS');
	exception
		when others then
		dbms_output.put_line('error while adding Dick'||sqlerrm);
	end;
	
	begin
		add_student('Mary', 'Myrtle', 'myrtle@gmail.com', 'MATH');
	exception
		when others then
		dbms_output.put_line('error while adding mary myrtle'||sqlerrm);
	end;
	
	begin
		add_student('Mary', 'Molley', 'molley@gmail.com', 'MATH');
	exception
		when others then
		dbms_output.put_line('error while adding mary molley'||sqlerrm);
	end;
	
	begin
		add_student('Mark', 'Miser', 'miser@gmail.com', 'MATH');
	exception
		when others then
		dbms_output.put_line('error while adding mark'||sqlerrm);
	end;
	
	begin
		add_student('Bruce', 'Benjie', 'benjie@gmail.com', 'BIO');
	exception
		when others then
		dbms_output.put_line('error while adding Bruce'||sqlerrm);
	end;
	
	begin
		add_student('Bandu', 'Bindu', 'bindu@gmail.com', 'BIO');
	exception
		when others then
		dbms_output.put_line('error while adding Bindu'||sqlerrm);
	end;
	
	dbms_output.put_line(CHR(10));
	
	-- select student table using cursor
	
	dbms_output.put_line('Students table details');
	dbms_output.put_line(CHR(10));
	for i in C_std loop
		dbms_output.put_line('Student first Name: '||i.firstName||' Last Name: '||i.lastName||' Email: '||i.email||' Department ID: '||i.departmentID);
	end loop;
	
		
	begin 
	s_id := find_student_id_withname('Mary','Myrtle');
	c_id := find_course_id_withname('MATH 100');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting Mary');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding mary course');
	end;

	begin 
	s_id := find_student_id_withname('Mary','Myrtle');
	c_id := find_course_id_withname('MATH 151');
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting Mary');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding mary course');
	end;

	begin 
	s_id := find_student_id_withname('Mary','Myrtle');
	c_id := find_course_id_withname('MATH 300');
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting Mary');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding mary course');
	end;
	
	
	-- enrolling mark in all MATH course 
	begin
	s_id := find_student_id_withname('Mark','Miser');
	if s_id> 0 then 
		for i in c_courseid('MATH') loop
	begin
		enroll_student(s_id,i.courseID);
	exception
		when others then
		dbms_output.put_line('error while enrolling Mark'||sqlerrm);
	end;
	end loop;
	else
		dbms_output.put_line('invalid student name in mark block');
	end if;
	end;
	
		
	-- enrolling collin in all IS courses
	begin
	s_id := find_student_id_withname('Collin','Cabobs');
	if s_id> 0 then 
		for i in c_courseid('IS') loop
	begin
		enroll_student(s_id,i.courseID);
	exception
		when others then
		dbms_output.put_line('error while enrolling collin'||sqlerrm);
	end;
	end loop;
	else
		dbms_output.put_line('invalid student name in collin block');
	end if;
	end;
	
	-- enrolling Abel in all CMSC courses
	begin
	s_id := find_student_id_withname('Abel','Apron');
	if s_id>0 then
		for i in c_courseid('CMSC') loop
	begin
		enroll_student(s_id,i.courseID);
	exception
		when others then
		dbms_output.put_line('error while enrolling Abel'||sqlerrm);
	end;
	end loop;
	else
		dbms_output.put_line('invalid student name in abel block');
	end if;
	end;
	
	--printing  show all student names enrolled in either CMSC or IS courses and the courses they are enrolled in.
	
	dbms_output.put_line('Students with CMSC or IS courses details');
	dbms_output.put_line(CHR(10));
	for i in C_output loop
		dbms_output.put_line('Student first Name: '||i.firstName||' Last Name: '||i.lastName||' Course Name: '||i.courseName);
	end loop;
	commit;
end;





