create schema ex05;
set search_path to ex05;

create table sales (
    sale_id serial primary key,
    customer_id int,
    amount numeric(10,2),
    sale_date date
);

insert into sales (customer_id, amount, sale_date) values
(1, 1500.00, '2026-04-01'),
(2, 2000.00, '2026-04-05'),
(1, 500.00, '2026-04-10'),
(3, 3000.00, '2026-04-15');

create or replace procedure calculate_total_sales(
    start_date date,
    end_date date,
    out total numeric
)
language plpgsql
as $$
begin
    select coalesce(sum(amount), 0) into total
    from sales
    where sale_date >= start_date and sale_date <= end_date;
end;
$$;

do $$
declare
    v_total numeric;
begin
    call calculate_total_sales('2026-04-01', '2026-04-10', v_total);
    raise notice 'tong doanh thu: %', v_total;
end $$;