create schema ex06;
set search_path to ex06;

create table accounts (
    account_id serial primary key,
    owner_name varchar(100),
    balance numeric(12,2),
    status varchar(10) default 'ACTIVE'
);

create table transactions (
    trans_id serial primary key,
    from_account int references accounts(account_id),
    to_account int references accounts(account_id),
    amount numeric(12,2),
    status varchar(20) default 'PENDING',
    created_at timestamp default now()
);

-- Insert dữ liệu theo yêu cầu
insert into accounts (owner_name, balance, status) values
('Tài khoản A', 5000.00, 'ACTIVE'),
('Tài khoản B', 2000.00, 'ACTIVE');

create or replace procedure banking_trans(
    send_acc_id int,
    rec_acc_id int,
    amount numeric
)
language plpgsql as $$
declare
    v_trans_id int;
    v_send_record record;
    v_rec_record record;
begin
    --Bắt đầu transaction
    begin
    --kiểm tra amount luôn dương
    if amount <= 0 then
        raise exception 'Tiền gửi phải luôn dương';
    end if;
    --Khóa tài khoản
    if send_acc_id < rec_acc_id then
        select * into v_send_record from accounts where account_id = send_acc_id for update;
        select * into v_rec_record from accounts where account_id = rec_acc_id for update;
    else
        select * into v_rec_record from accounts where account_id = rec_acc_id for update;
        select * into v_send_record from accounts where account_id = send_acc_id for update;
    end if;

    --Tạo log transaction
    insert into transactions(from_account, to_account, amount)
    values (send_acc_id, rec_acc_id, amount)
    returning trans_id into v_trans_id;

    --Kiểm tra tồn tại tài khoản
    if v_send_record is null or v_rec_record is null then
        raise exception 'tài khoản gửi hoặc nhận không tồn tại';
    end if;
    --Kiểm tra trạng thái tài khoản
    if v_send_record.status != 'ACTIVE' or v_rec_record.status != 'ACTIVE' then
        raise exception 'Tài khoản gửi hoặc nhận không còn hoạt động';
    end if;
    --Kiểm tra số dư tài khoản gửi
    if v_send_record.balance < amount then
        raise exception 'Tài khoản không đủ số dư';
    end if;

    --Tăng giảm balance
    update accounts
    set balance = balance - amount
    where account_id = send_acc_id;

    update accounts
    set balance = balance + amount
    where account_id = rec_acc_id;

    --Cập nhật trạng thái log
    update transactions
    set status = 'COMPLETED'
    where trans_id = v_trans_id;

    --Xử lý exception
    exception
        when others then
            rollback;
            raise;
    end;
end;
$$;

call banking_trans(1, 2, 500);

--Test lỗi không đủ số dư
call banking_trans(1, 2, 10000000);
--Test lỗi tài khoản không tồn tại
call banking_trans(1, 9, 500);
--Test lỗi tiền gửi không dương
call banking_trans(1, 2, 0);

--test lỗi trạng thái tài khoản
update accounts
set status = 'LOCKED'
where account_id = 1;
call banking_trans(1, 2, 500);

select * from accounts;
select * from transactions;