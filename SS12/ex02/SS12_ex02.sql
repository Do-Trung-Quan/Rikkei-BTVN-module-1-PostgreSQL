create schema ex03;
set search_path to ex03;

create table products(
    product_id serial primary key,
    name varchar(50),
    stock int
);

create table sales(
    sale_id serial primary key,
    product_id int references products(product_id),
    quantity int
);

insert into products(name, stock)
values ('nigga1', 50),
       ('nigga2', 100);

create or replace function func_bef_insert()
returns trigger as $$
begin
    --Kiểm tra tồn tại product
    if (select count(*) from products where product_id = new.product_id) < 1 then
        raise exception 'Không tìm thấy sản phẩm';
    end if;
    --Kiểm tra tồn kho
    if (select stock from products where product_id = new.product_id) < new.quantity then
        raise exception 'Không đủ tồn kho';
    end if;

    --Cập nhật tồn kho
    update products
    set stock = stock - new.quantity
    where product_id = new.product_id;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_bef_insert
before insert on sales
for each row
execute function func_bef_insert();

insert into sales(product_id, quantity)
values (1, 2);

select * from sales;
select * from products;
