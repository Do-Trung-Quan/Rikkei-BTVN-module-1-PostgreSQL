create schema ex04;
set search_path to ex04;

-- 1. Tạo bảng
create table products (
    id serial primary key,
    name varchar(100) not null,
    stock int default 0 check (stock >= 0)
);

create table orders (
    id serial primary key,
    product_id int references products(id),
    quantity int check (quantity > 0)
);

-- 2. Tạo dữ liệu mẫu cho bảng products
insert into products (name, stock) values
('Bàn phím cơ', 50),
('Chuột không dây', 30),
('Màn hình 24 inch', 20);

-- 3. Các câu lệnh DML cho bảng orders (Dùng để test Trigger)
create or replace function change_order()
returns trigger as $$
declare
    v_stock int default -1;
begin
    if tg_op = 'INSERT' then
        --1. Kiểm tra tồn kho có đủ để thêm đơn hàng không / Kiểm tra product có tồn tại không
        select stock into v_stock from products where id = new.id;
        if v_stock = -1 then
            raise exception 'product không tồn tại';
        elsif v_stock < new.quantity then
            raise exception 'Không đủ stock';
        end if;

        --2. Thực hiện nghiệp vụ cập nhật stock
        update products
        set stock = stock - new.quantity
        where id = new.id;

        return new;
    elsif tg_op = 'UPDATE' then
        --1. Kiểm tra tồn kho có đủ để sửa đơn hàng không
        select stock into v_stock from products where id = new.id;
        if new.quantity > old.quantity then
            --Kiểm tra stock
            if v_stock < new.quantity - old.quantity then
                raise exception 'Không đủ stock';
            end if;
        end if;

        --2. Thực hiện nghiệp vụ cập nhật stock
        update products
        set stock = stock - (new.quantity - old.quantity)
        where id = new.id;

        return new;
    elsif tg_op = 'DELETE' then
        --2. Thực hiện nghiệp vụ cập nhật stock
        update products
        set stock = stock + old.quantity
        where id = old.id;

        return old;
    end if;
end;
$$ language plpgsql;

create or replace trigger trg_before_insert_order
before insert on orders
for each row
execute function change_order();

create or replace trigger trg_before_update_order
    before update on orders
    for each row
execute function change_order();

create or replace trigger trg_before_delete_order
    after delete on orders
    for each row
execute function change_order();

-- Test Insert: Trừ stock
insert into orders (product_id, quantity)
values (1, 5);

-- Test Update: Cập nhật lại khoảng chênh lệch stock
update orders
set quantity = 10
where id = 1;

-- Test Delete: Trả lại stock
delete from orders
where id = 1;

select * from products;
select * from orders;