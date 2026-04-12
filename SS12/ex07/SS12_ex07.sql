create schema ex07;
set search_path to ex07;

create table products(
    product_id serial primary key,
    name varchar(50) not null ,
    price numeric(10,2) not null,
    stock int not null
);

create table orders(
    order_id serial primary key,
    product_id int references products(product_id),
    quantity int not null,
    total_amount numeric(10,2)
);

create table order_log(
    log_id serial primary key,
    order_id int,
    action_time timestamp
);

insert into products(name, price, stock)
values ('nigga1',30000, 50),
       ('nigga2', 100000, 100);

create or replace procedure add_order(
    p_pro_id int,
    p_quantity int
)
as $$
declare
    v_price numeric(10,2);
    v_total numeric(10,2);
    v_order_id int;
begin
    begin
    -- kiểm tra tồn tại sản phẩm
    if (select count(*) from products where product_id = p_pro_id) < 1 then
        raise exception 'không tồn tại sản phẩm';
    end if;
    -- kiểm tra tồn kho
    if (select stock from products where product_id = p_pro_id) < p_quantity then
        raise exception 'không đủ tồn kho';
    end if;

    -- tạo order
    select price into v_price from products where product_id = p_pro_id;
    select (v_price * p_quantity) into v_total;

    insert into orders(product_id, quantity, total_amount)
    values (p_pro_id, p_quantity, v_total)
    returning order_id into v_order_id;
    -- cập nhật tồn kho
    update products
    set stock = stock - p_quantity
    where product_id = p_pro_id;
    -- ghi log
    insert into order_log(order_id, action_time)
    values (v_order_id, now());

    -- xu lý exception
    exception
        when others then
            rollback;
            raise;
    end;
end;
$$ language plpgsql;

call add_order(1, 10);

call add_order(9, 10);

call add_order(1, 1000);

select * from orders;
select * from order_log;
select * from products;
