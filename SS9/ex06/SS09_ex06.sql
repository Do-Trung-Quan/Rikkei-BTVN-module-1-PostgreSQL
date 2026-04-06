create schema ex06;
set search_path to ex06;

create table products (
    product_id serial primary key,
    name varchar(100),
    price numeric(10,2),
    category_id int
);

insert into products (name, price, category_id) values
('laptop asus rog', 20000.00, 1),
('macbook pro 14', 30000.00, 1),
('bàn phím cơ rk68', 1000.00, 2),
('chuột logitech g102', 400.00, 2);

create or replace procedure update_product_price(
    p_category_id int,
    p_increase_percent numeric
)
language plpgsql
as $$
declare
    v_product record;
    v_new_price numeric(10,2);
begin
    for v_product in select product_id, price from products where category_id = p_category_id loop
        v_new_price := v_product.price * (1 + p_increase_percent / 100.0);

        update products
        set price = v_new_price
        where product_id = v_product.product_id;
    end loop;
end;
$$;

-- 1. Xem giá trước khi cập nhật
select * from products order by product_id;

-- 2. Gọi Procedure: Tăng giá 10% cho tất cả sản phẩm thuộc category_id = 1
call update_product_price(1, 10);

-- 3. Xem lại bảng
select * from products order by product_id;