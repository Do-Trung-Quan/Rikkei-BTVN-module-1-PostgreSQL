create schema ex06;
set search_path to ex06;

-- Bài xuất sắc 2: -- Order + Product

create table products (
    id serial primary key,
    name varchar(100) not null,
    stock int default 0
);

create table orders (
    id serial primary key,
    product_id int references products(id),
    quantity int check (quantity > 0),
    order_status varchar(50) default 'pending'
);

-- Chỉ insert dữ liệu cho bảng products theo yêu cầu
insert into products (name, stock) values
('laptop gaming msi', 10),
('bàn phím cơ akko', 50),
('chuột logitech g502', 30),
('tai nghe razer blackshark', 15),
('màn hình dell ultrasharp', 20);

-- 3 Trigger
-- Khi thêm đơn hàng:
-- Khi thêm thì phải trừ đi stock thông qua quantity ở order
-- Kiểm tra tồn kho trước khi trừ
-- stock = stock - NEW.quantity (Order)

create or replace trigger trg_after_insert_order
before insert on orders
for each row
execute function change_order();

create or replace trigger trg_after_update_order
    before update on orders
    for each row
execute function change_order();

create or replace trigger trg_after_delete_order
    after delete on orders
    for each row
execute function change_order();


create or replace function change_order()
    returns trigger as $$
declare
    v_stock int;
begin
    -- kiểm tra tồn kho

    IF (TG_OP = 'INSERT') THEN
        select stock into v_stock from products where id = new.product_id;
        if v_stock < new.quantity then
            raise exception 'Không đủ stock!';
        end if;

        update products
        set stock = v_stock - new.quantity
        where id = new.product_id;

        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        if(new.quantity > old.quantity) then
            select stock into v_stock from products where id = new.product_id;
            if v_stock < new.quantity - old.quantity then
                raise exception 'Không đủ stock!';
            end if;

        end if;

        update products
        set stock = stock - (new.quantity - old.quantity)
        where id = new.product_id;

        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        update products
        set stock = stock + (old.quantity)
        where id = old.product_id;

        RETURN OLD;
    end if;
end;
$$ language plpgsql;


insert into orders (product_id, quantity)
values (3, 1);

update orders
set quantity = 50
where id = 2;

select * from orders;
select * from products;
