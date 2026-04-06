create schema ex04;
set search_path to ex04;

create table sales (
    sale_id serial primary key,
    customer_id int,
    product_id int,
    sale_date date,
    amount numeric(10,2)
);

insert into sales (customer_id, product_id, sale_date, amount) values
(1, 101, '2026-04-01', 500.00),
(1, 102, '2026-04-02', 600.00),
(2, 101, '2026-04-03', 1500.00),
(3, 103, '2026-04-04', 300.00),
(2, 104, '2026-04-05', 200.00);

create view customersales as
select customer_id, sum(amount) as total_amount
from sales
group by customer_id;

select * from customersales
where total_amount > 1000;

-- ERROR: cannot update view "customersales"
update customersales
set total_amount = 2000
where customer_id = 1;