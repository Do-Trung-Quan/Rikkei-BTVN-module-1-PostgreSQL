-- 1. Tạo bảng phòng ban (departments)
create table departments (
                             dept_id serial primary key,
                             dept_name varchar(100)
);

-- 2. Tạo bảng nhân viên (employees)
create table employees (
                           emp_id serial primary key,
                           emp_name varchar(100),
                           dept_id int references departments(dept_id),
                           salary numeric(10,2),
                           hire_date date
);

-- 3. Tạo bảng dự án (projects)
create table projects (
                          project_id serial primary key,
                          project_name varchar(100),
                          dept_id int references departments(dept_id)
);

-- 4. Chèn dữ liệu mẫu
insert into departments (dept_name)
values
    ('IT'),
    ('Marketing'),
    ('HR');

insert into employees (emp_name, dept_id, salary, hire_date)
values
    ('Nguyễn Văn A', 1, 2500.00, '2023-01-15'),
    ('Trần Thị B', 1, 3000.50, '2022-05-20'),
    ('Lê Văn C', 2, 1800.00, '2024-02-10'),
    ('Phạm Minh D', 3, 2200.00, '2023-11-01');

insert into projects (project_name, dept_id)
values
    ('E-commerce Website', 1),
    ('Mobile App Development', 1),
    ('Brand Re-branding', 2),
    ('Employee Benefits System', 3);


--1. Hiển thị danh sách nhân viên gồm: Tên nhân viên, Phòng ban, Lương dùng bí danh bảng ngắn (employees as e,departments as d).
select e.emp_name, d.dept_name, e.salary from employees e left join departments d on e.dept_id = d.dept_id;

--2.
--a. Tổng quỹ lương toàn công ty
select sum(e.salary) as total from employees e;
--b. Mức lương trung bình
select avg(e.salary) as avg_sal from employees e;
--c. Lương cao nhất, thấp nhất
select max(e.salary) as max_sal, min(e.salary) as min_sal from employees e;
--d. Số nhân viên
select count(*) as num_of_emp from employees e;

--3.
--a. Tính mức lương trung bình của từng phòng ban
select d.dept_name, avg(e.salary) as avg_sal from employees e join departments d on e.dept_id = d.dept_id
group by d.dept_name;
--b. chỉ hiển thị những phòng ban có lương trung bình > 15.000.000
select d.dept_name, avg(e.salary) as avg_sal from employees e join departments d on e.dept_id = d.dept_id
group by d.dept_name
having avg(e.salary) > 15000000;

--4. Liệt kê danh sách dự án (project) cùng với phòng ban phụ trách và nhân viên thuộc phòng ban đó
select p.project_name, d.dept_name, e.emp_name from projects p left join departments d on p.dept_id = d.dept_id
left join employees e on d.dept_id = e.dept_id;


--5.
--a. Tìm nhân viên có lương cao nhất trong mỗi phòng ban
select e1.emp_name, d.dept_name, e1.salary from employees e1 join departments d on e1.dept_id = d.dept_id
where e1.salary in
(select max(e.salary) from employees e
group by e.dept_id);
