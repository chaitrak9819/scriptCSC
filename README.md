dbeaver - chaitra@123
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


Links among tables---------------------------------------------------------------------------------------------------------------------------------- 1)exams(exam_course_code,exam_course_rev, exam_course_type) --> grades (grade_course_code,grade_course_rev ,grade_exam_type_ref) *to be created 2)contacts(contact_email) --> students (student_contact_ref) 3)student(student_epita_email) --> grades (grade_student_epita_email_ref) 4)course(course_code, course_rev) --> programs (program_course_code , program_course_rev) 5)population --> students(student_population_code_ref, student_population_year_ref, student_population_period_ref) *to be created 6)courses(course_code, course_rev) --> exam (exam_course_code, exam_course_rev) *to be created 7)course(course_code, course_rev) --> sessions(session_course_ref, session_course_rev_ref) *to be created 8)teachers(teacher_epita_email) -->sessions(session_prof_ref) *to be created 9)population(population_year, population_period) --> sessions(session_population_year, session_population_period) [session_room] *to be created

10)student(student_epita_email) --> attendance(attendance_student_ref) *to be created ALTER TABLE attendance ADD CONSTRAINT students_attendance_fk FOREIGN KEY (attendance_student_ref) REFERENCES students(student_epita_email) ON DELETE SET NULL;

11)population(population_year) --> attendance(attendance_population_year_ref) *to be created 12)course(course_code, course_rev ) --> attendance(attendance_course_ref, attendance_course_rev) *to be created 13)sessions(session_date,session_start_time,session_end_time) --> attendance(attendance_session_date_ref,attendance_session_start_time,attendance_session_end_time) *to be created

Example queries----------------------------------------------------------------------------------------------------------------------------------------------- 1)select * from contacts c where contact_city ilike 'chicago'

2)SELECT grade_student_epita_email_ref, grade_score, RANK() OVER (partition by grade_student_epita_email_ref order by grade_score desc ) FROM grades

3)select count(student_epita_email) from students where student_population_period_ref like 'F%' group by student_population_period_ref

Sum(),count(),min(),max(),avg() have to apply with group by

4)select AVG(something) as Average_marks FROM ( select grade_score as something from grades g where grade_student_epita_email_ref='simona.morasca@epita.fr' ) MyAliasTable
https://learnsql.com/blog/tips-for-database-class-exam/ https://www.postgresqltutorial.com/

northwind-------------------------------------------------------------------------------------------------------------------- --1 list of customers select * from customers;

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

[7:33 PM] Sreedhar Sahana
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

