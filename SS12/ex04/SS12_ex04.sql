create schema ex04;
set search_path to ex04;

create table products(
    product_id serial primary key,
    name varchar(50),
    stock int,
    price numeric
);

create table orders(
    order_id serial primary key,
    product_id int references products(product_id),
    quantity int,
    total_amount numeric
);

insert into products(name, stock, price)
values ('nigga1', 50, 3000),
       ('nigga2', 100, 10000);

create or replace function func_bef_insert()
returns trigger as $$
declare
    v_price numeric;
begin
    --Kiểm tra tồn tại product
    if (select count(*) from products where product_id = new.product_id) < 1 then
        raise exception 'Không tìm thấy sản phẩm';
    end if;
    --Kiểm tra tồn kho
    if (select stock from products where product_id = new.product_id) < new.quantity then
        raise exception 'Không đủ tồn kho';
    end if;

    --Tính total amount
    select price into v_price from products where product_id = new.product_id;
    select (v_price * new.quantity) into new.total_amount;

    --Cập nhật tồn kho
    update products
    set stock = stock - new.quantity
    where product_id = new.product_id;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_bef_insert
before insert on orders
for each row
execute function func_bef_insert();

insert into orders(product_id, quantity)
values (1, 2),
    (1, 20),
    (2, 10);

insert into orders(product_id, quantity)
values (1, 200);


select * from orders;
select * from products;
