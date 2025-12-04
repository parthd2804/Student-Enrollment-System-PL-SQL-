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
foreign key (courseID) references courses(courseID),
UNIQUE (studentID, courseID)
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

--create helper function find_studentid_with_name_email
--input student firstname, lastname , email
--output studentid

create or replace function find_studentid_with_name_email(s_fname varchar, s_lname varchar, e_mail varchar) return int is
s_id int;
begin
	select studentID into s_id from students where firstName= s_fname AND lastName=s_lname AND email = e_mail;
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

-- create function course_average
-- input course id
-- return number
create or replace function course_average (c_id int) return number is
cursor c_student is select grade from enrollments where courseID=c_id and grade IN('A', 'B', 'C', 'D', 'F');
total_point number;
total_student number;
average number;
begin

total_point:= 0;
total_student:= 0;
average:= 0;

for i in c_student loop

	if i.grade = 'A' then
		total_point := total_point + 4;
	elsif i.grade ='B' then
		total_point := total_point + 3;
	elsif i.grade ='C' then
		total_point := total_point + 2;
	elsif i.grade ='D' then
		total_point := total_point + 1;
	elsif i.grade ='F' then
		total_point := total_point + 0;
	end if;

total_student := total_student + 1;
end loop;

 if total_student =0 then
	  dbms_output.put_line('no graded student found for this course');
	  return -1;
 else
	average:= total_point/total_student;
	return average;
end if;

exception
	when others then
	dbms_output.put_line('SQL ERROR:'||sqlerrm);
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
		dbms_output.put_line('enrollment added');
		
	else
		dbms_output.put_line('invalid student id or course id');
	end if;

exception 
    when others then
	dbms_output.put_line('sql error in procedure'||sqlerrm);
end;
/

--create assign_grade procedure
-- input studetn id, course id , grade
-- ouput successful assign grade for that course to that student in enrollments table 

create or replace procedure assign_grade(s_id int,c_id int, grade varchar) IS
s_grade varchar(2);
begin

	s_grade:= upper (grade); --convert grade into uppercase
	
    --making sure if provide grade is valid or not

	if s_grade not in ('A', 'B', 'C', 'D', 'F') then 
	
		dbms_output.put_line('invalid grade input please enter correct grade for A,B,C,D,F');
	else
		
		update enrollments set grade= s_grade where studentID=s_id And courseID=c_id;

    --checking if update is successful or not
		if sql%rowcount = 0 then 
			dbms_output.put_line('no matching enrollment entry found for this courseID and studentID');
		else
			dbms_output.put_line('grade update successfully');
		end if;
		
	end if;

exception

	when others then
	dbms_output.put_line('Sql error'||sqlerrm);
end;
/


--create students_in_course procedure
-- input course id
-- output course details, student details enrolled for that course, student distrubution on department

create or replace procedure students_in_course(c_id int) IS

cursor c_details IS select c.courseName, c.credits, d.departmentName from courses c, departments d where c.departmentID=d.departmentID and c.courseID = c_id;
cursor s_details Is select s.firstName, s.lastName, s.email , d.departmentName from students s, departments d, enrollments e where s.departmentID=d.departmentID And e.studentID= s.studentID And e.courseID=c_id;
cursor c_distribution IS select d.departmentName, count(*) as total_student from departments d, enrollments e, students s where s.departmentID=d.departmentID and e.studentID=s.studentID and e.courseID=c_id group by d.departmentName;
begin
	dbms_output.put_line(CHR(10));
	dbms_output.put_line('Course details');
	for i in c_details loop
		dbms_output.put_line('Course Name: '||i.courseName||' credits: '||i.credits||' Department Name: '||i.departmentName);
	end loop;

	dbms_output.put_line(CHR(10));
	dbms_output.put_line('students details who are enrolled into this course');
	for i in s_details loop
		dbms_output.put_line('student first Name: '||i.firstname||', last name: '||i.lastname||', email: '||i.email||', Department Name: '||i.departmentName);
	end loop;

	dbms_output.put_line(CHR(10));
	dbms_output.put_line('details about enrolled student for course id '||c_id|| ' distribution over department');
	for i in c_distribution loop
		dbms_output.put_line(i.departmentName||'   '||i.total_student);
	end loop;

exception
	when others then
	dbms_output.put_line('Sql Error'||sqlerrm);
end;
/

--create annonymous block

set serveroutput on size 100000;
declare
s_id int;
c_id int;
-- cursor to print student table
cursor c_std is select * from students;
-- cursor to get courses from pattern
cursor c_courseid(course_pattern varchar) is select courseID from courses  where courseName LIKE course_pattern||'%';	
--cursor to select student and course name which are in CMSC or IS course
cursor c_output is select s.firstname, s.lastname, c.courseName from students s, courses c, enrollments e where s.studentid=e.studentid and c.courseid=e.courseID and (c.coursename Like 'CMSC%' OR c.coursename Like 'IS%');
type course_array is VARRAY(10) of varchar2(50);
course_list course_array;
avg_grade number;

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
	
 -- assign_grade Collin cabob A in IS 410
 
	begin
		s_id:= find_studentid_with_name_email('Collin', 'Cabobs', 'cabobs@gmail.com');
		c_id:= find_course_id_withname('IS 410');
		
		assign_grade(s_id, c_id, 'A');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to callin cabob for IS 410'||sqlerrm);
	end;
	
  -- assign_grade Collin cabob A in IS 420
 
	begin
		s_id:= find_studentid_with_name_email('Collin', 'Cabobs', 'cabobs@gmail.com');
		c_id:= find_course_id_withname('IS 420');
		
		assign_grade(s_id, c_id, 'A');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to callin cabob for IS 420'||sqlerrm);
	end; 

  -- assign_grade Collin cabob A in IS 436
 
	begin
		s_id:= find_studentid_with_name_email('Collin', 'Cabobs', 'cabobs@gmail.com');
		c_id:= find_course_id_withname('IS 436');
		
		assign_grade(s_id, c_id, 'B');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to callin cabob for IS 436'||sqlerrm);
	end;

  -- assign_grade Isaac Istiq C in IS 410
 
	begin
		s_id:= find_studentid_with_name_email('Isaac', 'Istiq', 'istiq@gmail.com');
		c_id:= find_course_id_withname('IS 410');
		
		assign_grade(s_id, c_id, 'C');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to callin cabob for IS 410'||sqlerrm);
	end;
-- enroll Dick Disney in Math 100

	begin 
	s_id := find_studentid_with_name_email('Dick','Disney','disney@gmail.com');
	c_id := find_course_id_withname('MATH 100');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting dick disney');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding dick disney course');
	end;
	
-- enroll Collin Cabobs in Math 100

	begin 
	s_id := find_studentid_with_name_email('Collin','Cabobs','cabobs@gmail.com');
	c_id := find_course_id_withname('MATH 100');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting collins');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding collins course');
	end;

-- enroll Bandu Bindu in Math 100

	begin 
	s_id := find_studentid_with_name_email('Bandu','Bindu','bindu@gmail.com');
	c_id := find_course_id_withname('MATH 100');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting Bandu');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding Bandu course');
	end;
	
-- enroll Abel Apron in Math 100

	begin 
	s_id := find_studentid_with_name_email('Abel','Apron','apron@gmail.com');
	c_id := find_course_id_withname('MATH 100');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting abel');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding abel course');
	end;
	
-- enroll Dick disney in IS 610

	begin 
	s_id := find_studentid_with_name_email('Dick','Disney','disney@gmail.com');
	c_id := find_course_id_withname('IS 610');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting dick disney');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding Dick course');
	end;

-- enroll Dick disney in IS 620

	begin 
	s_id := find_studentid_with_name_email('Dick','Disney','disney@gmail.com');
	c_id := find_course_id_withname('IS 620');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting dick disney');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding Dick course');
	end;	
	
-- enroll Dick disney in IS 700

	begin 
	s_id := find_studentid_with_name_email('Dick','Disney','disney@gmail.com');
	c_id := find_course_id_withname('IS 700');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting dick disney');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding Dick course');
	end;
	
  -- assign_grade dick disney C in IS 610
 
	begin
		s_id:= find_studentid_with_name_email('Dick', 'Disney', 'disney@gmail.com');
		c_id:= find_course_id_withname('IS 610');
		
		assign_grade(s_id, c_id, 'C');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to dick disney for IS 610'||sqlerrm);
	end;
	
  -- assign_grade dick disney B in IS 620
 
	begin
		s_id:= find_studentid_with_name_email('Dick', 'Disney', 'disney@gmail.com');
		c_id:= find_course_id_withname('IS 620');
		
		assign_grade(s_id, c_id, 'B');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to dick disney for IS 620'||sqlerrm);
	end;

  -- assign_grade dick disney B in IS 700
 
	begin
		s_id:= find_studentid_with_name_email('Dick', 'Disney', 'disney@gmail.com');
		c_id:= find_course_id_withname('IS 700');
		
		assign_grade(s_id, c_id, 'B');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to dick disney for IS 700'||sqlerrm);
	end;
	
  -- assign_grade Collin Cabobs c in IS 700
 
	begin
		s_id:= find_student_id_withname('Collin', 'Cabobs');
		c_id:= find_course_id_withname('IS 700');
		
		assign_grade(s_id, c_id, 'C');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to Collin Cabobs for IS 610'||sqlerrm);
	end;

-- enroll Bandu Bindu in Bio 602

	begin 
	s_id := find_studentid_with_name_email('Bandu','Bindu','bindu@gmail.com');
	c_id := find_course_id_withname('BIO 602');
	
	if s_id>0 and c_id>0 then
		enroll_student(s_id,c_id);
	else
		dbms_output.put_line('invalid student name or course name while inserting Bandu');
	end if;
	exception
		when others then
		dbms_output.put_line('error while adding Bandu course');
	end;
	
  -- assign_grade Bandu Bindu B in BIO 602
 
	begin
		s_id:= find_studentid_with_name_email('Bandu', 'Bindu','bindu@gmail.com');
		c_id:= find_course_id_withname('BIO 602');
		
		assign_grade(s_id, c_id, 'B');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to bandu for BIO 602'||sqlerrm);
	end;
	
  -- assign_grade Collin Cabobs A in MATH 100
 
	begin
		s_id:= find_studentid_with_name_email('Collin', 'Cabobs','cabobs@gmail.com');
		c_id:= find_course_id_withname('MATH 100');
		
		assign_grade(s_id, c_id, 'A');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to Collin Cabobs for MATH 100'||sqlerrm);
	end;
	
  -- assign_grade Bandu Bindu B in Math 100
 
	begin
		s_id:= find_studentid_with_name_email('Bandu', 'Bindu','bindu@gmail.com');
		c_id:= find_course_id_withname('MATH 100');
		
		assign_grade(s_id, c_id, 'B');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to bandu for Math 100'||sqlerrm);
	end;
	
  -- assign_grade Abel Apron B in Math 100
 
	begin
		s_id:= find_studentid_with_name_email('Abel', 'Apron', 'apron@gmail.com');
		c_id:= find_course_id_withname('MATH 100');
		
		assign_grade(s_id, c_id, 'B');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to Apron for math 100'||sqlerrm);
	end;
	
  -- assign_grade Abel Apron A in CMSC 202
 
	begin
		s_id:= find_studentid_with_name_email('Abel', 'Apron', 'apron@gmail.com');
		c_id:= find_course_id_withname('CMSC 202');
		
		assign_grade(s_id, c_id, 'A');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to apron in CMSC 202'||sqlerrm);
	end;
	
  -- assign_grade Mary Myrtle A in MATH 100
 
	begin
		s_id:= find_student_id_withname('Mary', 'Myrtle');
		c_id:= find_course_id_withname('MATH 100');
		
		assign_grade(s_id, c_id, 'A');
	exception 
		when others then
			dbms_output.put_line('error while assigning grade to Mary in MATH 100'||sqlerrm);
	end;
	
	--gettting details for MATH 100
	c_id := find_course_id_withname('MATH 100');
	students_in_course(c_id);
	
	dbms_output.put_line(CHR(10));
	-- calling average function
	dbms_output.put_line('Average Grades:');
	course_list:= course_array('MATH 100', 'IS 610', 'IS 620', 'IS 700', 'BIO 602', 'CMSC 202');
	
	for i in 1..course_list.COUNT loop
		begin
		c_id := find_course_id_withname(course_list(i));
		avg_grade := course_average(c_id);
		
		if avg_grade >= 0 then 
			dbms_output.put_line(course_list(i)||' = '||avg_grade);
		else
			dbms_output.put_line('no student graded in this course or no student enrolled in this course');
		end if;
		
		exception
		
		when others then
			dbms_output.put_line('error for ' || course_list(i) ||sqlerrm );
		end;
	end loop;
	
	commit;
end;





