create schema ex04;

set search_path to ex04;

create table orderinfo (
    id serial primary key,
    customer_id int,
    order_date date,
    total numeric(10,2),
    status varchar(20)
);

insert into orderinfo (customer_id, order_date, total, status) values
(1, '2024-10-05', 750000.00, 'Completed'),
(2, '2024-10-15', 300000.00, 'Pending'),
(3, '2024-09-20', 1200000.00, 'Processing'),
(1, '2024-10-25', 600000.00, 'Cancelled'),
(4, '2024-11-01', 450000.00, 'Completed');

select * from orderinfo
where total > 500000;

select * from orderinfo
where extract(month from order_date) = 10 and extract(year from order_date) = 2024;

select * from orderinfo
where status != 'Completed';

select * from orderinfo
order by order_date desc
limit 2;