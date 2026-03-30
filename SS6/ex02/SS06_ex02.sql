create schema ex02;

set search_path to ex02;

create table employee (
    id serial primary key,
    full_name varchar(100),
    department varchar(50),
    salary numeric(10,2),
    hire_date date
);

insert into employee (full_name, department, salary, hire_date) values
('Đỗ Trung Quân', 'IT', 12000000.00, '2023-06-15'),
('Nguyễn Hải An', 'Marketing', 15000000.00, '2023-08-20'),
('Trần Thị Thu An', 'HR', 5500000.00, '2022-11-10'),
('Lê Hoàng Nam', 'IT', 18000000.00, '2024-01-05'),
('Phạm Quang Anh', 'Sales', 5000000.00, '2023-02-15'),
('Vũ Thị Lan', 'Accounting', 20000000.00, '2021-06-30');

update employee
set salary = salary * 1.1
where department = 'IT';

delete from employee
where salary < 6000000;

select * from employee
where full_name ilike '%an%';

select * from employee
where hire_date between '2023-01-01' and '2023-12-31';