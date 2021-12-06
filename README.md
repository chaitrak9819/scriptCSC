dbeaver - chaitra@123
chaitra-basayya.kadur@epita.fr
cK% P? 8J &

Username : chaitra-basayya.kadur
Password : RxZXpCKn

schemas- right click- create new schema- give name
for the given schema -right click- sql editor-new sql scpit
rename the new file
file1- ddl
file2- inserst
in insert---check the reference key, if it exits paste thr previous table
leave the ref part do others, in second round do the refernce.

Order of inserts:

DDL

courses
programs
contacts
exams
populations
sessions
students
teachers 
grades
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Links among tables--------1)exams(exam_course_code,exam_course_rev, exam_course_type) --> grades (grade_course_code,grade_course_rev ,grade_exam_type_ref) *to be created 2)contacts(contact_email) --> students (student_contact_ref) 3)student(student_epita_email) --> grades (grade_student_epita_email_ref) 4)course(course_code, course_rev) --> programs (program_course_code , program_course_rev) 5)population --> students(student_population_code_ref, student_population_year_ref, student_population_period_ref) *to be created 6)courses(course_code, course_rev) --> exam (exam_course_code, exam_course_rev) *to be created 7)course(course_code, course_rev) --> sessions(session_course_ref, session_course_rev_ref) *to be created 8)teachers(teacher_epita_email) -->sessions(session_prof_ref) *to be created 9)population(population_year, population_period) --> sessions(session_population_year, session_population_period) [session_room] *to be created

10)student(student_epita_email) --> attendance(attendance_student_ref) *to be created ALTER TABLE attendance ADD CONSTRAINT students_attendance_fk FOREIGN KEY (attendance_student_ref) REFERENCES students(student_epita_email) ON DELETE SET NULL;

11)population(population_year) --> attendance(attendance_population_year_ref) *to be created 12)course(course_code, course_rev ) --> attendance(attendance_course_ref, attendance_course_rev) *to be created 13)sessions(session_date,session_start_time,session_end_time) --> attendance(attendance_session_date_ref,attendance_session_start_time,attendance_session_end_time) *to be created

Example queries-----------------------------------------------------------------------------------------------------------------------------------------------
1)select * from contacts c where contact_city ilike 'chicago'

2)SELECT grade_student_epita_email_ref, grade_score, RANK() OVER (partition by grade_student_epita_email_ref order by grade_score desc ) FROM grades

3)select count(student_epita_email) from students where student_population_period_ref like 'F%' group by student_population_period_ref

Sum(),count(),min(),max(),avg() have to apply with group by

4)select AVG(something) as Average_marks FROM ( select grade_score as something from grades g where grade_student_epita_email_ref='simona.morasca@epita.fr' ) MyAliasTable
https://learnsql.com/blog/tips-for-database-class-exam/ https://www.postgresqltutorial.com/

northwind-------------------------------------------------------------------------------------------------------------------- --
1 list of customers select * from customers;

--2 number of different products select count(distinct product_name) from products;

--3 count of employees select count(employee_id) from employees;

--4 unit_price * quantity - unit_price * quantity * discount total overall revenue select sum(unit_price * quantity * (1 - discount)) from order_details;

--5 total revenue for one specific year select sum(unit_price * quantity * (1 - discount)) from order_details where order_id in (select order_id from orders where order_date between '1996-01-01' and '1996-12-31');

--6 list of countries covered by delivery select distinct ship_country from orders order by ship_country asc;

--7 list of available transporters select company_name from shippers order by company_name asc;

--8 number of customer per countries select country ,count(customer_id) as cnt from customers group by country order by cnt desc;

--9 number of orders which are "ordered" but not shipped select count(order_id) from orders where shipped_date is null;

--10 all the orders from france and belgium select * from orders where lower(ship_country) like 'france' or upper(ship_country) like 'BELGIUM'; --10 all the orders from france and belgium select * from orders where ship_country ilike 'france' or ship_country ilike 'BELGIUM'; --10 all the orders from france and belgium select * from orders where ship_country in ('France','Belgium');

--11 most expensive products with product_price_rank as ( select product_name,quantity_per_unit,unit_price,categories.category_name , rank() over(partition by products.category_id order by unit_price desc) as rnk from products join categories on categories.category_id = products.category_id ) select product_name,quantity_per_unit,unit_price,category_name,rnk from product_price_rank where rnk <= 5; --11 most expensive products select product_name,quantity_per_unit,unit_price,category_name,rnk from ( select product_name,quantity_per_unit,unit_price,categories.category_name , rank() over(partition by products.category_id order by unit_price desc) as rnk from products join categories on categories.category_id = products.category_id ) as product_price_rank where rnk <= 5;

--12 list of discontinued products select * from products where discontinued = 1 order by product_name;

--13 count of product per category select c.category_name, count(p.product_id) from products p left join categories c on c.category_id = p.category_id group by c.category_id order by c.category_name;

--14 average order price with sumPerOrder as ( select order_id, sum((1-discount) * unit_price * quantity) as sumPerOrder from order_details od group by order_id ) select avg(sumPerOrder) from sumPerOrder;

--15 revenue per category select c.category_name, sum( (1-discount) * od.unit_price * od.quantity) from products left join categories c on products.category_id = c.category_id left join order_details od on od.product_id = products.product_id group by c.category_id order by c.category_name;

--16 number of orders per shipper select s.company_name, count(o.order_id) as number_of_orders from orders o join shippers s on o.ship_via = s.shipper_id group by s.shipper_id;

--17 number of orders per employee select concat(e.first_name, ' ', e.last_name) as employee_full_name , count(o.order_id) as number_of_orders from orders o join employees e on o.employee_id = e.employee_id group by e.employee_id order by employee_full_name asc;

--18 total revenue per supplier select s.company_name, cast(sum( (1-discount) * od.unit_price * od.quantity) as integer) from products p left join suppliers s on p.supplier_id = s.supplier_id left join order_details od on od.product_id = p.product_id group by s.supplier_id order by s.company_name;

--19 insert a product with its category INSERT INTO categories (category_id, category_name, description, picture) VALUES(9, 'New Category Name', 'New Category description', categoryImageBytes); INSERT INTO products (product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued) VALUES(78, 'New Product name', 1, 9, 'Quantity per unit', 8, 100, 0, 10, 0);

--20 create an order (what is required?) INSERT INTO orders (order_id, customer_id, employee_id, order_date, required_date, shipped_date, ship_via, freight, ship_name, ship_address, ship_city, ship_region, ship_postal_code, ship_country) VALUES(11078, customer_id, employee_id, 'order_date', 'required_date', '', ship_via, freight, 'ship_name', 'ship_address', 'ship_city', 'ship_region', 'ship_postal_code', 'ship_country'); --Required: customer,shipper and employee ids, then insert into order_details for each product ordered by the customer INSERT INTO order_details (order_id, product_id, unit_price, quantity, discount) VALUES(11078, 78, 8, 2, 0); INSERT INTO order_details (order_id, product_id, unit_price, quantity, discount) VALUES(11078, 77, 13, 2, 0);

--21 change the shipped delivery date UPDATE orders SET shipped_date='2021-11-30' WHERE order_id=11078;

Order of inserts:
DDL 
courses--5 
programs--9 
contacts--1 
exams--6
populations--2
sessions--7 
students--3 
teachers--4
attendance--8
grades--10


--joining the 3 tables (bookings, facilities and members) SELECT f.name,m.firstname,b.starttime,b.slots FROM bookings as b left join facilities AS f on b.facid = f.facid left join members as m on b.memid = m.memid where m.firstname like 'T%';

--count facilities rows with condition SELECT count(facid) as cnt FROM facilities where monthlymaintenance < 200;

--rank example SELECT NAME,MONTHLYMAINTENANCE, RANK() OVER( ORDER BY NAME DESC ) FROM facilities ;

--group by example (memid and month) SELECT members.memid as memberid,extract(month from starttime) as "month", members.firstname, count(bookings.bookid) as cnt FROM bookings LEFT JOIN members ON members.memid = bookings.memid GROUP BY members.memid,"month" order by memberid;

-- sub selects (traditional) SELECT memberid, cnt, FROM ( SELECT bookings.memid as memberid, count(bookings.bookid) as cnt FROM bookings LEFT JOIN members ON members.memid = bookings.memid GROUP BY bookings.memid ORDER BY cnt desc ) mem_bookings;

--sub selects (Postgresql) WITH mem_bookings as ( SELECT bookings.memid as memberid, count(bookings.bookid) as cnt FROM bookings LEFT JOIN members ON members.memid = bookings.memid GROUP BY bookings.memid ORDER BY cnt desc ) SELECT memberid, cnt FROM mem_bookings;
--left join select * from table_a as a left join table_b as b on a.pk = b.pk;

--left join exclusive select * from table_a as a left join table_b as b on a.pk = b.pk where b.pk is NULL;

--right join select * from table_a as a right join table_b as b on a.pk = b.pk;

--right join exclusive select * from table_a as a right join table_b as b on a.pk = b.pk where a.pk is NULL;

--inner join select * from table_a as a join table_b as b on a.pk = b.pk;

--full outer join select * from table_a as a full outer join table_b as b on a.pk = b.pk;

--full outer join exclusive select * from table_a as a full outer join table_b as b on a.pk = b.pk WHERE A.PK IS NULL OR B.PK IS NULL;
![image](https://user-images.githubusercontent.com/95567903/144755766-f4e61328-8b3b-453e-9ee2-5a368548ae89.png)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Easy qsts (no relations needed)
1- Get all enrolled students for a specific period,program,year ?
2- Get number of enrolled students for a specific period,program,year
3- Get All defined exams for a course from grades table
4-Get all grades for a student
5-Get all grades for a specific Exam
6-Get students Ranks in an Exam for a course
7-Get students Ranks in all exams for a course
8-Get students Rank in all exams in all courses
9-Get all courses for one program
10-Get courses in common between 2 programs
11-Get all programs following a certain course
12- get course with the biggest duration
13-get courses with the same duration
14-Get all sessions for a specific course
15-Get all session for a certain period
16-Get one student attendance sheet
17- Get one student summary of attendance
18-Get student with most absences
Hard questions (build the relations requiered)
1- Get all exams for a specific Course
2- Get all Grades for a specific Student
3- Get the final grades for a student on a specifique course or all courses
4-Get the students with the top 5 scores for specific course
5-Get the students with the top 5 scores for specific course
per rank
6-Get the Class average for a course
--bonuses:
1-Get a student full report of grades and attendances
2- -- Get a student full report of grades ,ranks per course  and attendances
Those questions are from easy to super hard

-- Get all enrolled students for a specific period,program,year ?
select s.* from students s where s.student_population_period_ref ='SPRING' and s.student_population_code_ref = 'SE' and s.student_population_year_ref =2021;

-- Get number of enrolled students for a specific period,program,year
select count(s.student_enrollment_status) from students s where s.student_population_period_ref ='SPRING' and s.student_population_code_ref = 'SE' and s.student_population_year_ref =2021;

-- Get All defined exams for a course from grades table
select distinct(g.grade_exam_type_ref) from grades g where g.grade_course_code_ref ='SE_ADV_JAVA';

-- Get all grades for a student
select  g.grade_score from grades g where g.grade_student_epita_email_ref ='viva.toelkes@epita.fr';

-- Get all grades for a specific Exam
select g.grade_score from grades g where g.grade_exam_type_ref = 'Project';


-- Get students Ranks in an Exam for a course
-- solution 1 per intake & year
select rank() over(order by g.grade_score desc), g.grade_score from students s right join grades g 
on s.student_epita_email = g.grade_student_epita_email_ref where g.grade_student_epita_email_ref is not null and s.student_population_year_ref =2021 and s.student_population_period_ref ='SPRING' and g.grade_course_code_ref ='SE_ADV_JAVA' and g.grade_exam_type_ref ='Project';

-- solution 2 general
select rank() over(order by g.grade_score desc), g.grade_score from grades g where  g.grade_course_code_ref ='SE_ADV_JAVA' and g.grade_exam_type_ref ='Project';

-- Get students Ranks in all exams for a course
-- solution 1 per intake & year
select rank() over(order by g.grade_score desc), g.grade_score from students s right join grades g on s.student_epita_email = g.grade_student_epita_email_ref where g.grade_student_epita_email_ref is not null and s.student_population_year_ref =2021 and s.student_population_period_ref ='SPRING' and g.grade_course_code_ref ='SE_ADV_JAVA';

-- solution 2 general
select rank() over(order by g.grade_score desc), g.grade_score from grades g where  g.grade_course_code_ref ='SE_ADV_JAVA';

-- Get students Rank in all exams in all courses
-- solution 1 per intake & year
select rank() over(order by g.grade_score desc), g.grade_score from students s right join grades g on s.student_epita_email = g.grade_student_epita_email_ref where g.grade_student_epita_email_ref is not null and s.student_population_year_ref =2021 and s.student_population_period_ref ='SPRING';

-- solution 2 general
select rank() over(order by g.grade_score desc), g.grade_score from grades g;

-- Get all courses for one program
select p.program_course_code_ref from programs p where p.program_assignment ='SE';

-- Get courses in common between 2 programs
SELECT distinct(program_course_code_ref) program_assignment FROM programs where program_assignment = 'SE'
intersect
SELECT distinct(program_course_code_ref) program_assignment FROM programs where program_assignment = 'AIs'

-- Get all programs following a certain course
select p.program_assignment from programs p where p.program_course_code_ref = 'DT_RDBMS';

-- get course with the biggest duration
-- solution 1
select c.* from courses c order by c.duration desc limit 1;

-- solution 2
select c.* from courses c where c.duration = (select max(c2.duration) from courses c2);

-- get courses with the same duration 
select * from courses c where c.duration in (select c2.duration from courses c2 group by c2.duration having count(c2.duration) > 1) order by c.duration asc


-- Get all sessions for a specific course
-- solution 1
select s.* from sessions s where s.session_course_ref ='DT_RDBMS';

-- solution 2
select s.* from sessions s where s.session_course_ref ='DT_RDBMS' and s.session_population_year =2020 and s.session_population_period ='FALL';

-- Get all session for a certain period
select s.* from sessions s where s.session_date  >= '2021-01-04' and s.session_date  <= '2021-01-31';


-- Get one student attendance sheet
select a.attendance_course_ref, a.attendance_session_date_ref, a.attendance_session_start_time, a.attendance_session_end_time,
case when a.attendance_presence = 1 then 'Present'
	else 'Absent' 
end as marksheet
from attendance a where a.attendance_student_ref = 'jamal.vanausdal@epita.fr'

-- Get one student summary of attendance
select
  total_attendance, 
  sum_attendance,
  (sum_attendance / total_attendance :: float)* 100 attendance_percentage, 
  res.attendance_student_ref, 
  res.attendance_course_ref, 
  res.attendance_population_year_ref 
from 
  (
    select 
      count(1) as total_attendance, 
      sum(s.attendance_presence) as sum_attendance, 
      s.attendance_student_ref, 
      s.attendance_course_ref, 
      s.attendance_population_year_ref 
    from 
      attendance as s 
    where 
      s.attendance_student_ref = 'albina.glick@epita.fr' 
    group by 
      s.attendance_student_ref, 
      s.attendance_course_ref, 
      s.attendance_population_year_ref
  ) res 
order by 
  attendance_percentage
-- courses per specialization
select p.program_assignment, count(p.program_assignment) as courses_count from programs p group by p.program_assignment;


-- semester count per specialization
select p.program_assignment, p.program_course_rev_ref as semester, count(p.program_course_rev_ref) as courses_count from programs p group by p.program_assignment, p.program_course_rev_ref order by p.program_assignment, p.program_course_rev_ref asc;


-- get all session types
select distinct(s.session_type) from sessions s;


-- get all room name
select distinct(s.session_room) from sessions s where s.session_room is not null ;


-- per intake, count of sessions and per year
select s.session_population_period, count(s.*),  from sessions s where s.session_population_year = 2021 group by s.session_population_period;


-- sessions per month [range]
select s.* from sessions s where s.session_date >= '2020-09-01' and s.session_date < '2020-10-01';


-- sessions handled by teachers [not duplicate]
select distinct(s.session_prof_ref) from sessions s;


-- started session count of the particular year intake
select s.session_population_period, count(s.*) from sessions s where s.session_population_year = 2021 group by s.session_population_period;


-- insert population for all specilization
insert into populations (population_code, population_year, population_period) select p.population_code as pcode, max(p.population_year) as pyear, 'FALL' as intake from populations p group by p.population_code;


-- order by teacher's level 
select t.* from teachers t order by t.teacher_study_level asc


-- get all teachers from contacts table
select c.* from contacts c left join teachers t on c.contact_email = t.teacher_contact_ref where t.teacher_contact_ref is not null;


-- get all students from contacts table
select c.* from contacts c left join students s on c.contact_email = s.student_contact_ref where s.student_contact_ref is not null;


-- get all students from contacts table and where newyork students
select c.* from contacts c left join students s on c.contact_email = s.student_contact_ref where s.student_contact_ref is not null and c.contact_city  ilike 'los angeles';


-- get all students from contacts table and where birthday is on november
select c.* from contacts c left join students s on c.contact_email = s.student_contact_ref where s.student_contact_ref is not null and date_part('month', c.contact_birthdate::date) = 11;

-- calculate age from dob 
SELECT contact_first_name, date_part('year',age(contact_birthdate)) as contact_age,* FROM contacts;


-- add age column to contacts
alter table contacts add column contact_age integer NULL;

-- calculate age from dob and insert in col contact_age
update 
  contacts as c1 
set 
  contact_age = (
    SELECT 
      date_part(
        'year', 
        age(contact_birthdate)
      ) as c_age 
    FROM 
      contacts as c2 
    where 
      c1.contact_email = c2.contact_email
  );
 
 
-- avg student age
select 
  avg(c.contact_age) as student_avg_age 
from 
  students as s 
  left join contacts as c on c.contact_email = s.student_contact_ref
 
-- get students population in each year
select student_population_year_ref, count(1) from students group by student_population_year_ref;


-- get students population in each program
select student_population_code_ref, count(1) from students group by student_population_code_ref;
  

-- students count who completed the diploma in particular year according to the specilization
select s.student_population_code_ref, count(*) from students s where s.student_enrollment_status ='completed' and s.student_population_year_ref =2021 group by s.student_population_code_ref;


/* avg grade for SE students*/
select 
  avg(g.grade_score) as avg_grade, 
  pop.population_code as population 
from 
  grades as g 
  inner join programs as p on g.grade_course_code_ref = p.program_course_code_ref 
  inner join populations as pop on pop.population_code = p.program_assignment 
where 
  pop.population_code = 'SE' 
group by 
  pop.population_code


/* All student average grade*/
Select cont.contact_first_name, cont.contact_last_name, stud.student_epita_email, avg(g.grade_score)
from students stud
  inner join contacts cont
  on cont.contact_email = stud.student_contact_ref
  
  inner join grades g
  on stud.student_epita_email = g.grade_student_epita_email_ref

group by cont.contact_first_name, cont.contact_last_name, stud.student_epita_email


/* attendance percentage for a student */
select 
  (sum_atten / total_atten :: float)* 100 attendance_percentage, 
  res.attendance_student_ref, 
  res.attendance_course_ref, 
  res.attendance_population_year_ref 
from 
  (
    select 
      count(1) as total_atten, 
      sum(s.attendance_presence) as sum_atten, 
      s.attendance_student_ref, 
      s.attendance_course_ref, 
      s.attendance_population_year_ref 
    from 
      attendance as s 
    where 
      s.attendance_student_ref = 'albina.glick@epita.fr' 
    group by 
      s.attendance_student_ref, 
      s.attendance_course_ref, 
      s.attendance_population_year_ref
  ) res 
order by 
  attendance_percentage


/* list the course tought by teacher */
select 
  distinct con.contact_first_name, 
  con.contact_last_name, 
  sess.session_course_ref 
from 
  teachers tea 
  inner join contacts con on con.contact_email = tea.teacher_contact_ref 
  inner join sessions sess on tea.teacher_epita_email = sess.session_prof_ref


-- find the teachers who are not giving any courses
select 
  s.student_epita_email 
from 
  students as s 
where 
  s.student_epita_email not in (
    select 
      g.grade_student_epita_email_ref 
    from 
      grades as g
  )

/* 
 * find the SE students details with grades
 */
select 
  con.contact_first_name, 
  con.contact_last_name, 
  stud.student_population_code_ref, 
  grad.grade_course_code_ref as course_name, 
  grad.grade_score 
from 
  grades grad 
  inner join students stud on grad.grade_student_epita_email_ref = stud.student_epita_email 
  inner join contacts con on stud.student_contact_ref = con.contact_email 
where 
  student_population_code_ref = 'SE'

  
/*
 * list of teacher who attend the total session 
 */
select 
  con.contact_first_name, 
  con.contact_last_name, 
  tea.teacher_contact_ref, 
  count(session_prof_ref) 
from 
  teachers tea 
  inner join contacts con on con.contact_email = tea.teacher_contact_ref 
  inner join sessions sess on tea.teacher_epita_email = sess.session_prof_ref 
group by 
  con.contact_first_name, 
  con.contact_last_name, 
  tea.teacher_contact_ref 
order by 
  count

  

/*
 * find the teachers who are not in any session
 */
  
SELECT 
  c.contact_first_name, 
  c.contact_last_name, 
  t.teacher_epita_email 
from 
  contacts as c 
  inner join teachers as t on c.contact_email = t.teacher_contact_ref 
  LEFT OUTER JOIN sessions as s ON t.teacher_epita_email = s.session_prof_ref 
WHERE 
  s.session_prof_ref IS NULL


/*
 * find students who are not graded
 */
  
-- SOLUTION NUMBER 1
SELECT 
  a.student_epita_email, 
  b.grade_score 
FROM 
  students a 
  LEFT JOIN grades b ON a.student_epita_email = b.grade_student_epita_email_ref 
WHERE 
  b.grade_score IS NULL

-- SOLUTION NUMBER 2
SELECT 
  s.student_epita_email 
FROM 
  students as s 
WHERE 
  NOT EXISTS (
    SELECT 
      * 
    FROM 
      grades as g 
    WHERE 
      s.student_epita_email = g.grade_student_epita_email_ref
  )
  
-- SOLUTION NUMBER 3
SELECT 
  s.student_epita_email 
FROM 
  students as s 
  LEFT OUTER JOIN grades as g ON (
    s.student_epita_email = g.grade_student_epita_email_ref
  ) 
WHERE 
  g.grade_student_epita_email_ref IS NULL


/*
 * find the student with most absents TOP 10
 */
select 
  count(a.attendance_student_ref) as absents, 
  c.contact_first_name, 
  c.contact_last_name 
from 
  contacts as c 
  left join students as s on s.student_contact_ref = c.contact_email 
  left join attendance as a on s.student_epita_email = a.attendance_student_ref 
where 
  a.attendance_presence = 1 
group by 
  c.contact_first_name, 
  c.contact_last_name 
order by 
  absents ASC 
limit 
  10

  
/*
 * find the course with most absents
 */
SELECT 
  b.course_name, 
  count(a.attendance_presence) absences 
FROM 
  attendance a 
  LEFT JOIN courses b ON a.attendance_course_ref = b.course_code 
WHERE 
  attendance_presence = 0 
GROUP BY 
  a.attendance_course_ref, 
  b.course_name 
ORDER BY 
  Absences DESC 
LIMIT 
  1;

 
/*
 * avg session duration for a course
 */
select 
  avg(
    EXTRACT(
      EPOCH 
      FROM 
        TO_TIMESTAMP(session_end_time, 'HH24:MI:SS'):: TIME - TO_TIMESTAMP(
          session_start_time, 'HH24:MI:SS'
        ):: TIME
    )/ 3600
  ) as duration 
from 
  sessions as s 
  left join courses as c on c.course_code = s.session_course_ref 
where 
  c.course_code = 'DT_RDBMS'


--Note: Need to set foreign keys for session.session_course_ref , session.session_course_rev_ref with course table 






New codes


-- Get all enrolled students for a specific period,program,year ?
select s.* from students s where s.student_population_period_ref ='SPRING' and s.student_population_code_ref = 'SE' and s.student_population_year_ref =2021;

-- Get number of enrolled students for a specific period,program,year
select count(s.student_enrollment_status) from students s where s.student_population_period_ref ='SPRING' and s.student_population_code_ref = 'SE' and s.student_population_year_ref =2021;

-- Get All defined exams for a course from grades table
select distinct(g.grade_exam_type_ref) from grades g where g.grade_course_code_ref ='SE_ADV_JAVA';

-- Get all grades for a student
select  g.grade_score from grades g where g.grade_student_epita_email_ref ='viva.toelkes@epita.fr';

-- Get all grades for a specific Exam
select g.grade_score from grades g where g.grade_exam_type_ref = 'Project';


-- Get students Ranks in an Exam for a course
-- solution 1 per intake & year
select rank() over(order by g.grade_score desc), g.grade_score from students s right join grades g 
on s.student_epita_email = g.grade_student_epita_email_ref where g.grade_student_epita_email_ref is not null and s.student_population_year_ref =2021 and s.student_population_period_ref ='SPRING' and g.grade_course_code_ref ='SE_ADV_JAVA' and g.grade_exam_type_ref ='Project';

-- solution 2 general
select rank() over(order by g.grade_score desc), g.grade_score from grades g where  g.grade_course_code_ref ='SE_ADV_JAVA' and g.grade_exam_type_ref ='Project';

-- Get students Ranks in all exams for a course
-- solution 1 per intake & year
select rank() over(order by g.grade_score desc), g.grade_score from students s right join grades g on s.student_epita_email = g.grade_student_epita_email_ref where g.grade_student_epita_email_ref is not null and s.student_population_year_ref =2021 and s.student_population_period_ref ='SPRING' and g.grade_course_code_ref ='SE_ADV_JAVA';

-- solution 2 general
select rank() over(order by g.grade_score desc), g.grade_score from grades g where  g.grade_course_code_ref ='SE_ADV_JAVA';

-- Get students Rank in all exams in all courses
-- solution 1 per intake & year
select rank() over(order by g.grade_score desc), g.grade_score from students s right join grades g on s.student_epita_email = g.grade_student_epita_email_ref where g.grade_student_epita_email_ref is not null and s.student_population_year_ref =2021 and s.student_population_period_ref ='SPRING';

-- solution 2 general
select rank() over(order by g.grade_score desc), g.grade_score from grades g;

-- Get all courses for one program
select p.program_course_code_ref from programs p where p.program_assignment ='SE';

-- Get courses in common between 2 programs
SELECT distinct(program_course_code_ref) program_assignment FROM programs where program_assignment = 'SE'
intersect
SELECT distinct(program_course_code_ref) program_assignment FROM programs where program_assignment = 'AIs'

-- Get all programs following a certain course
select p.program_assignment from programs p where p.program_course_code_ref = 'DT_RDBMS';

-- get course with the biggest duration
-- solution 1
select c.* from courses c order by c.duration desc limit 1;

-- solution 2
select c.* from courses c where c.duration = (select max(c2.duration) from courses c2);

-- get courses with the same duration 
select * from courses c where c.duration in (select c2.duration from courses c2 group by c2.duration having count(c2.duration) > 1) order by c.duration asc


-- Get all sessions for a specific course
-- solution 1
select s.* from sessions s where s.session_course_ref ='DT_RDBMS';

-- solution 2
select s.* from sessions s where s.session_course_ref ='DT_RDBMS' and s.session_population_year =2020 and s.session_population_period ='FALL';

-- Get all session for a certain period
select s.* from sessions s where s.session_date  >= '2021-01-04' and s.session_date  <= '2021-01-31';


-- Get one student attendance sheet
select a.attendance_course_ref, a.attendance_session_date_ref, a.attendance_session_start_time, a.attendance_session_end_time,
case when a.attendance_presence = 1 then 'Present'
  else 'Absent' 
end as marksheet
from attendance a where a.attendance_student_ref = 'jamal.vanausdal@epita.fr'

-- Get one student summary of attendance
select
  total_attendance, 
  sum_attendance,
  (sum_attendance / total_attendance :: float)* 100 attendance_percentage, 
  res.attendance_student_ref, 
  res.attendance_course_ref, 
  res.attendance_population_year_ref 
from 
  (
    select 
      count(1) as total_attendance, 
      sum(s.attendance_presence) as sum_attendance, 
      s.attendance_student_ref, 
      s.attendance_course_ref, 
      s.attendance_population_year_ref 
    from 
      attendance as s 
    where 
      s.attendance_student_ref = 'albina.glick@epita.fr' 
    group by 
      s.attendance_student_ref, 
      s.attendance_course_ref, 
      s.attendance_population_year_ref
  ) res 
order by 
  attendance_percentage
  

-- Get student with most absences
  select * from (select attendance_student_ref , count(attendance_presence) from attendance where attendance_presence = 0 group by attendance_student_ref) as OP1 order by OP1.count desc limit 1;
  
-- Get all exams for a specific Course
select e.exam_type from courses c right join exams e on e.exam_course_code = c.course_code where e.exam_course_code is not null and c.course_code  = 'DT_RDBMS';


-- Get all Grades for a specific Student
select grade_score from grades where grade_student_epita_email_ref = 'simona.morasca@epita.fr'

-- Get the students with the top 5 scores for specific course
select OP4.contact_first_name,OP4.contact_last_name,OP4.grade_score from
((select OP2.student_contact_ref , OP2.grade_score from
((select grade_student_epita_email_ref ,grade_score from grades where grade_course_code_ref = 'CS_DATA_PRIV' order by grade_score desc limit 5) as OP1
left join students on OP1.grade_student_epita_email_ref = students.student_epita_email) as OP2) as OP3
left join contacts on OP3.student_contact_ref = contacts.contact_email) as OP4

-- Get the students with the top 5 scores for specific course per rank
select grade_student_epita_email_ref , rank () over (partition by grade_course_rev_ref order by grade_score desc ) FROM grades where grade_course_code_ref = 'SE_ADV_JS' limit 5

-- Get the Class average for a course
select 
  avg(
    EXTRACT(
      EPOCH 
      FROM 
        TO_TIMESTAMP(session_end_time, 'HH24:MI:SS'):: TIME - TO_TIMESTAMP(
          session_start_time, 'HH24:MI:SS'
        ):: TIME
    )/ 3600
  ) as duration 
from 
  sessions as s 
  left join courses as c on c.course_code = s.session_course_ref 
where 
  c.course_code = 'DT_RDBMS'
  
Get all Grades for a specific Student
select distinct grade_score, student_epita_email,grade_course_code_ref
from grades inner join students
on grades.grade_student_epita_email_ref = students.student_epita_email where grade_student_epita_email_ref ='jamal.vanausdal@epita.fr'
  
  
-- Get a student full report of grades and attendances
  
-- Get a student full report of grades ,ranks per course  and attendances
  
  
  
  
  
  
  
  
  
  






