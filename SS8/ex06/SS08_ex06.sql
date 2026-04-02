create schema ex02;
set search_path to ex02;

create table employees (
    id serial primary key,
    name varchar(100) not null,
    department varchar(50),
    salary numeric(10,2),
    bonus numeric(10,2) default 0
);

insert into employees (name, department, salary) values
('nguyen van a', 'hr', 4000),
('tran thi b', 'it', 6000),
('le van c', 'finance', 10500),
('pham thi d', 'it', 8000),
('do van e', 'hr', 12000);

create or replace procedure calculate_bonus(
    p_emp_id int,
    p_percent numeric,
    out p_bonus numeric
)
language plpgsql
as $$
    declare
        bonus numeric(10,2);
begin
    select (salary * p_percent)/100 into bonus from employees where id = p_emp_id;
    if not FOUND then
        raise exception 'Employee not found';
    end if;

    if p_percent <= 0 then
        p_bonus = 0;
    else
        p_bonus = bonus;
        update employees
        set bonus = p_bonus
        where id = p_emp_id;
    end if;
end;
$$;

call calculate_bonus(3, 50, 0);
select * from employees;
