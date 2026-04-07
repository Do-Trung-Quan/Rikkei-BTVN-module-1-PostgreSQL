create schema ex05;
set search_path to ex05;

create table customers (
    id serial primary key,
    name varchar(100) not null,
    email varchar(100) unique,
    phone varchar(20),
    address text
);

create table customers_log (
    log_id serial primary key,
    customer_id int,
    operation varchar(10) not null,
    old_data jsonb,
    new_data jsonb,
    changed_by varchar(100),
    change_time timestamp default now()
);

--1. Tạo hàm thực thi trigger
create or replace function change_customer()
returns trigger as $$
begin
    if tg_op = 'INSERT' then
        insert into customers_log(customer_id, operation, old_data, new_data, changed_by)
        values (new.id, 'insert', null, to_jsonb(new), current_user);

        return new;
    elsif tg_op = 'UPDATE' then
        insert into customers_log(customer_id, operation, old_data, new_data, changed_by)
        values (new.id, 'update', to_jsonb(old), to_jsonb(new), current_user);

        return new;
    elsif tg_op = 'DELETE' then
        insert into customers_log(customer_id, operation, old_data, new_data, changed_by)
        values (old.id, 'delete', to_jsonb(old), null, current_user);

        return old;
    end if;
end;
$$ language plpgsql;

--2. Định nghĩa Trigger
create or replace trigger trg_after_insert_customer
after insert on customers
for each row
execute function change_customer();

create or replace trigger trg_after_update_customer
    after update on customers
    for each row
execute function change_customer();

create or replace trigger trg_after_delete_customer
    after delete on customers
    for each row
execute function change_customer();

--Hành động:
insert into customers (name, email, phone, address)
values
('do trung quan', 'quandt@gmail.com', '0988776655', 'quận Hà Đông, Hà Nội'),
('le van dat', 'datlv@gmail.com', '0912345678', 'quận Thanh Xuân, Hà Nội'),
('tran thi mai', 'maitt@gmail.com', '0922334455', 'quận Hoàn Kiếm, Hà Nội');

update customers
set address = 'quận Đống Đa, Hà Nội', email = 'quan.do@gmail.com'
where name = 'do trung quan';

delete from customers
where id = 5;

select * from customers;
select * from customers_log;