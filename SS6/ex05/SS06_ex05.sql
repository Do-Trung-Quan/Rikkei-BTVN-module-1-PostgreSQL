create schema ex05;

set search_path to ex05;

create table course (
    id serial primary key,
    title varchar(100),
    instructor varchar(50),
    price numeric(10,2),
    duration int
);

insert into course (title, instructor, price, duration) values
('Java Spring Boot thuc chien', 'Do Trung Quan', 1500000.00, 40),
('Backend Node.js co ban', 'Linh Senior', 1200000.00, 25),
('Toi uu truy van SQL', 'Tran Thi B', 800000.00, 20),
('Khoa hoc ReactJS', 'Le Van C', 2500000.00, 35),
('Demo khoa hoc Python', 'Pham D', 0.00, 5),
('Hoc PostgreSQL trong 1 ngay', 'Do Trung Quan', 600000.00, 10),
('Thiet ke he thong (System Design)', 'Linh Senior', 3000000.00, 50);

update course
set price = price * 1.15
where duration > 30;

delete from course
where title like '%Demo%';

select * from course
where title ilike '%sql%';

select * from course
where price between 500000 and 2000000
order by price desc
limit 3;