create schema ex01;
set search_path to ex01;

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

create or replace procedure update_employee_status(
    p_emp_id int,
    out p_status text
)
language plpgsql
as $$
    declare
        e_sal int;
begin
    select salary into e_sal from employees where id = p_emp_id;
    if not found then
        raise exception 'employee not found';
    end if;

    if e_sal < 5000 then
        p_status := 'Junior';
    elsif e_sal >=5000 and e_sal <=10000 then
        p_status :='Middle';
    else
        p_status := 'Senior';
    end if;
end;
$$;

call update_employee_status(0, '');
