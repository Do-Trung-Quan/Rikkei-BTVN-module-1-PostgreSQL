create schema ex03;
set search_path to ex03;

create table employees (
    id serial primary key,
    name varchar(100) not null,
    position varchar(100),
    salary numeric(15,2)
);

create table employees_log (
    log_id serial primary key,
    employee_id int,
    operation varchar(10) not null,
    old_data jsonb,
    new_data jsonb,
    change_time timestamp default now()
);

create or replace function change_emp()
returns trigger as $$
begin
    if tg_op = 'INSERT' then
        insert into employees_log(employee_id, operation, old_data, new_data)
        values (new.id, 'Insert', null, to_jsonb(new));

        return new;
    elsif tg_op = 'UPDATE' then
        insert into employees_log(employee_id, operation, old_data, new_data)
        values (new.id, 'Update', to_jsonb(old), to_jsonb(new));

        return new;
    elsif tg_op = 'DELETE' then
        insert into employees_log(employee_id, operation, old_data, new_data)
        values (old.id, 'Delete', to_jsonb(old), null);

        return old;
    end if;
end;
$$ language plpgsql;

create or replace trigger trg_after_insert_employees
after insert on employees
for each row
execute function change_emp();

create or replace trigger trg_after_update_employees
    after update on employees
    for each row
execute function change_emp();

create or replace trigger trg_after_delete_employees
    after delete on employees
    for each row
execute function change_emp();

-- 1. Lệnh INSERT (Thêm mới nhân viên)
-- Thêm 3 nhân viên với các vị trí và mức lương khác nhau
insert into employees (name, position, salary)
values
    ('nguyen van a', 'junior developer', 15000000.00),
    ('tran thi b', 'project manager', 35000000.00),
    ('le van c', 'tester', 12000000.00);

-- 2. Lệnh UPDATE (Cập nhật thông tin)
-- Thăng cấp và tăng lương cho nhân viên có id = 1
update employees
set position = 'mid-level developer', salary = 18000000.00
where id = 1;

-- 3. Lệnh DELETE (Xóa nhân viên)
-- Xóa nhân viên có id = 3 khỏi hệ thống
delete from employees
where id = 3;

select * from employees;
select * from employees_log;