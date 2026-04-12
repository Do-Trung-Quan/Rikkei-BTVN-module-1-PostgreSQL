create schema ex05;
set search_path to ex05;

-- 1. Tạo bảng customers
create table customers (
    customer_id serial primary key,
    name varchar(100),
    balance numeric(12,2)
);

-- 2. Tạo bảng products
create table products (
    product_id serial primary key,
    name varchar(100),
    stock int,
    price numeric(10,2)
);

-- 3. Tạo bảng orders
create table orders (
    order_id serial primary key,
    customer_id int references customers(customer_id),
    total_amount numeric(12,2),
    created_at timestamp default now(),
    status varchar(20) default 'PENDING'
);

-- 4. Tạo bảng order_items
create table order_items (
    item_id serial primary key,
    order_id int references orders(order_id),
    product_id int references products(product_id),
    quantity int,
    subtotal numeric(10,2)
);

-- 5. Insert dữ liệu mẫu cho bảng customers
insert into customers (name, balance) values
('Nguyen Van A', 15000000.00),
('Tran Thi B', 25000000.00),
('Do Trung Quan', 5000000.00);

-- 6. Insert dữ liệu mẫu cho bảng products
insert into products (name, stock, price) values
('Bàn phím cơ', 50, 1200000.00),
('Chuột không dây', 100, 450000.00),
('Màn hình 24 inch', 20, 3500000.00);

create or replace procedure add_orders(p_cus_id int, p1_pro_id int, p1_quantity int, p2_pro_id int, p2_quantity int)
language plpgsql as $$
    declare
        v1_subtotal numeric(10,2);
        v2_subtotal numeric(10,2);
        v_total numeric(10,2);
        v_order_id int;
begin
    begin
        --kiểm tra tồn tại của product
        if (select count(*) from products where product_id = p1_pro_id or product_id = p2_pro_id) < 2 then
            raise exception 'Không tìm thấy mặt hàng';
        end if;
        --kiểm tra tồn kho
        if (select products.stock from products where product_id = p1_pro_id) < p1_quantity or (select products.stock from products where product_id = p2_pro_id) < p2_quantity then
            raise exception 'không đủ tồn kho';
        end if;
        --tính số tiền và tổng tiền
        select (select price from products where product_id = p1_pro_id) * p1_quantity into v1_subtotal;
        select (select price from products where product_id = p2_pro_id) * p2_quantity into v2_subtotal;
        select v1_subtotal + v2_subtotal into v_total;

        --kiểm tra balance của customer
        if (select customers.balance from customers where customer_id = p_cus_id) < v_total then
            raise exception 'Số tiền trong tài khoản khách không đủ';
        end if;

        --Tạo đơn hàng mới
        insert into orders (customer_id, total_amount)
        values (p_cus_id, v_total)
        returning order_id into v_order_id;
        --tạo đơn hàng chi tiết
        insert into order_items(order_id, product_id, quantity, subtotal)
        values (v_order_id, p1_pro_id, p1_quantity, v1_subtotal);

        insert into order_items(order_id, product_id, quantity, subtotal)
        values (v_order_id, p2_pro_id, p2_quantity, v2_subtotal);
        --cập nhật tồn kho + ví khách
        update products
        set stock = stock - p1_quantity
        where product_id = p1_pro_id;

        update products
        set stock = stock - p2_quantity
        where product_id = p2_pro_id;

        update customers
        set balance = balance - v_total
        where customer_id = p_cus_id;

        --Cập nhật status đơn hàng
        update orders
        set status = 'Completed'
        where order_id = v_order_id;

        --Xử lý lỗi
        exception
            when others then
                rollback ;
                raise ;
    end;
end;
$$;

call add_orders(2, 1, 1, 3, 2);

--test lỗi không đủ stock
call add_orders(2, 1, 1000, 3, 2);
--test lỗi không đủ balance
update customers
set balance = 0
where customer_id = 2;
call add_orders(2, 1, 1, 3, 2);
--test lỗi không tồn tại product
call add_orders(2, 9, 1, 3, 2);

select * from customers;
select * from products;
select * from orders;
select * from order_items;