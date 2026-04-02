create schema ex04;
set search_path to ex04;

create table employees (
    emp_id serial primary key,
    emp_name varchar(100),
    job_level int,
    salary numeric
);

insert into employees (emp_name, job_level, salary) values
('nguyen van a', 1, 15000000.00),
('tran thi b', 2, 25000000.00),
('le van c', 3, 45000000.00),
('pham thi d', 1, 18000000.00),
('do trung quan', 2, 30000000.00);

create or replace procedure adjust_salary(
    p_emp_id int,
    out p_new_salary numeric
)
language plpgsql
as $$
    declare
        level int;
        sal numeric;
begin
    select job_level, salary into level, sal from employees where emp_id = p_emp_id;
    if(level = 1) then
        p_new_salary := sal*1.05;
    elsif level = 2 then
        p_new_salary := sal*1.1;
    else
        p_new_salary := sal*1.15;
    end if;
    update employees set salary = p_new_salary where emp_id = p_emp_id;
end;
$$;

call adjust_salary(1, 0);
select * from employees;
