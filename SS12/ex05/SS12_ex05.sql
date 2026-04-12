create schema ex05;
set search_path to ex05;

create table employees(
    emp_id serial primary key,
    name varchar(50),
    position varchar(50)
);

create table employees_log(
    log_id serial primary key,
    emp_name varchar(50),
    action_time timestamp
);

insert into employees(name, position)
values ('nigga1', 'intern'),
       ('nigga2', 'CTO');

create or replace function func_change_emp()
returns trigger as $$
begin
    if tg_op = 'INSERT' then
        insert into employees_log(emp_name, action_time)
        values (new.name, now());

        return new;
    elsif tg_op = 'UPDATE' then
        insert into employees_log(emp_name, action_time)
        values (new.name, now());

        return new;
    elsif tg_op = 'DELETE' then
        insert into employees_log(emp_name, action_time)
        values (old.name, now());

        return old;
    end if;
end;
$$ language plpgsql;

create or replace trigger trg_aft_update
after update on employees
for each row
execute function func_change_emp();

update employees
set name = 'nigger1'
where emp_id = 1;

select * from employees;
select * from employees_log;
