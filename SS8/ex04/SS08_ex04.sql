create schema ex03;
set search_path to ex03;

create table products (
    id serial primary key,
    name varchar(100),
    price numeric,
    discount_percent int
);

insert into products (name, price, discount_percent) values
('laptop dell xps 13', 25000000.00, 10),
('iphone 15 pro', 28000000.00, 5),
('chuột logitech mx master 3', 2500000.00, 0),
('bàn phím cơ keychron k2', 1800000.00, 15),
('màn hình lg ultragear', 8500000.00, 20);

create or replace procedure calculate_discount(
    p_id int,
    out p_final_price numeric
)
language plpgsql
as $$
    declare
        p_price numeric;
        p_disc int;
begin
    select price, discount_percent into p_price, p_disc from products where id = p_id;
    if p_disc > 50 then
        p_disc := 50;
    end if;
    p_final_price := p_price - (p_price * p_disc / 100);
    update products set price = p_final_price where id = p_id;
end;
$$;

call calculate_discount(1, 0);
select * from products;
