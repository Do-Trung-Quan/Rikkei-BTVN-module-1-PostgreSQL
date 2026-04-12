create schema ex03;
set search_path to ex03;

-- 1. Tạo bảng products
create table products (
    product_id serial primary key,
    product_name varchar(100),
    stock int,
    price numeric(10,2)
);

-- 2. Tạo bảng orders
create table orders (
    order_id serial primary key,
    customer_name varchar(100),
    total_amount numeric(10,2),
    created_at timestamp default now()
);

-- 3. Tạo bảng order_items (bảng chi tiết đơn hàng)
create table order_items (
    order_item_id serial primary key,
    order_id int references orders(order_id),
    product_id int references products(product_id),
    quantity int,
    subtotal numeric(10,2)
);

-- 4. Insert dữ liệu mẫu chỉ cho bảng products
insert into products (product_name, stock, price) values
('Bàn phím cơ Royal Kludge RK68', 50, 1200000.00),
('Chuột Logitech G102', 100, 450000.00),
('Màn hình LG 24 inch', 30, 3500000.00),
('Tai nghe HyperX Cloud II', 20, 2100000.00),
('Laptop Asus TUF Gaming', 10, 25000000.00);


-- Transaction
create or replace procedure add_orders(p1_id int, p1_quantity int, p2_id int, p2_quantity int)
language plpgsql as $$
    declare
        v1_price numeric(10,2);
        v2_price numeric(10,2);
        v_order_id int;
begin
    begin
        --Kiểm tra tồn tại sản phẩm
        if (select count(*) from products where product_id = p1_id or product_id = p2_id) < 2 then
            raise exception 'không tìm thấy sản phẩm';
        end if;
        --Kiem tra tồn kho
        if (select products.stock from products where product_id = p1_id) < p1_quantity or (select products.stock from products where product_id = p2_id) < p2_quantity then
            raise exception 'không đủ stock';
        end if;

        --Tạo bản ghi order + orderDetail
        select products.price into v1_price from products where product_id = p1_id;
        select products.price into v2_price from products where product_id = p2_id;
        insert into orders(customer_name, total_amount)
        values ('Nguyễn Văn A', 0)
        returning order_id into v_order_id;

        insert into order_items(order_id, product_id, quantity, subtotal)
        values (v_order_id, p1_id, p1_quantity, v1_price*p1_quantity),
               (v_order_id, p2_id, p2_quantity, v2_price*p2_quantity);

        update orders
        set total_amount = (select sum(order_items.subtotal) from order_items where order_items.order_id = v_order_id)
        where order_id = v_order_id;
        --cap nhat product
        update products
        set stock = stock - p1_quantity
        where product_id = p1_id;

        update products
        set stock = stock - p2_quantity
        where product_id = p2_id;

        exception
            when others then
                rollback ;
                raise ;
    end;
end;
$$;

call add_orders(1,2,2,1);

call add_orders(1,2000,2,1);

call add_orders(1,2,9,1);

select *
from products;
select *
from orders;
select *
from order_items;