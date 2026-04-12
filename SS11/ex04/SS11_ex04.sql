create schema ex04;
set search_path to ex04;

-- 1. Tạo bảng accounts
create table accounts (
    account_id serial primary key,
    customer_name varchar(100),
    balance numeric(12,2)
);

-- 2. Tạo bảng transactions
create table transactions (
    trans_id serial primary key,
    account_id int references accounts(account_id),
    amount numeric(12,2),
    trans_type varchar(20), -- 'WITHDRAW' hoặc 'DEPOSIT'
    created_at timestamp default now()
);

-- 3. Insert dữ liệu mẫu chỉ cho bảng accounts
insert into accounts (customer_name, balance) values
('do trung quan', 15000000.00),
('nguyen thuy linh', 50000000.00),
('le van dat', 20000000.00),
('tran thi mai', 500000.00);

create or replace procedure withdraw(p_id int, amount numeric)
as $$
    declare
        v_bal numeric(10,2);
begin
    begin
    --Kiểm tra balance account
    if(select count(*) from accounts where account_id = p_id) < 1 then
        raise exception 'account not found';
    end if;

    select balance into v_bal from accounts where account_id = p_id;
    if v_bal < amount then
        raise exception 'not enough balance';
    end if;

    --trừ số dư và thêm log
    update accounts
    set balance = balance - amount
    where account_id = p_id;

    insert into transactions(account_id, amount, trans_type)
    values (p_id, amount, 'withdraw');

    exception
        when others then
            rollback ;
            raise ;
    end;
end;
$$ language plpgsql;

call withdraw(2, 100000);
call withdraw(2, 100000000);
call withdraw(9, 100000);

select *
from accounts;
select *
from transactions;


