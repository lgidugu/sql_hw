use sakila;
#1a
select first_name, last_name from actor;
#1b
select concat(first_name, ' ', last_name) as 'Actor Name'
from actor;
#2a
select actor_id, first_name, last_name 
from actor
where first_name = 'JOE';
#2b
select first_name, last_name
from actor
where last_name like '%GEN%';
#2c
select last_name, first_name
from actor
where last_name like '%LI%';
#2d
select c.country_id, c.country
from country c
where c.country in ('Afghanistan', 'Bangladesh', 'China');
#3a
alter table actor
add column middle_name varchar(15) after first_name;
#3b
alter table actor
change column middle_name middle_name blob;
#3c
alter table actor
drop middle_name;
select* from actor
#4a
select last_name as 'Last Name', count(last_name) as 'No. of actors with Last Name'
from actor
group by last_name;
#4b
select last_name as 'Last Name', count(last_name) as 'No. of actors with Last Name'
from actor
group by last_name
having count(last_name)>=2;
#4c
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

#4d
update actor 
set first_name = case when first_name = 'HARPO' then 'GROUCHO' 
	else 'MUCHO GROUCHO'
end
	where actor_id = 172;
   

#5a
create table address(
	address_id int(5) no null
    address varchar(50) no null
    address2 varchar(50)
    district varchar(15) no null
    city_id int(5)
    postal_code int(5) no null
    phone int(12) no null
    location geometry no null
    last_update timestamp no null
    primary key(address_id)
    );

#6a
select s.first_name, s.last_name, a.address
from staff s
left join address a on
s.address_id = a.address_id
#6b
select a.first_name, a.last_name, b.gross
from (staff as a inner join (select staff_id, sum(amount) as gross from payment group by staff_id) as b
on a.staff_id = b.staff_id)

#6c
select a.title, b.actors_count
from (film as a inner join(select film_id, count(actor_id)  as actors_count from film_actor group by film_id) as b
on a.film_id = b.film_id)
#6d
select t.title, i.film_count
from (film as t inner join (select film_id, count(inventory_id) as film_count from inventory group by film_id) as i
on t.film_id = i.film_id)
where t.title = 'Hunchback Impossible';
 
#6e
select c.first_name, c.last_name, p.payment_total
from(customer as c left join (select customer_id, count(amount) as payment_total from payment group by customer_id) as p
on c.customer_id = p.customer_id)
order by c.last_name, c.first_name 

#7a
select f.title 
from film f 
where f.title like 'K%' or f.title like 'Q%'
and f.language_id in (select a.language_id from language as a where a.name = 'English')

#7b
select a.first_name, a.last_name from actor a
where a.actor_id in (select f.actor_id from film_actor as f 
where f.film_id in (select a.film_id from film as a where a.title = 'Alone Trip'));

#7c
SELECT 
    c.first_name, c.last_name, c.email
FROM
    (customer AS c
    INNER JOIN (SELECT 
        e.country_id, e.city_id, a.address_id
    FROM
        (address AS a
    INNER JOIN (SELECT 
        b.country_id, b.city_id
    FROM
        (city AS b
    INNER JOIN (SELECT 
        country_id
    FROM
        country
    WHERE
        country = 'Canada') AS d ON b.country_id = d.country_id)) AS e ON a.city_id = e.city_id)) AS f ON f.address_id = c.address_id);

#7d
SELECT 
    title AS Family_Movie_List
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));

#7e
SELECT 
    title, rental_duration
FROM
    film
ORDER BY rental_duration DESC
LIMIT 5

#7f

select b.store_id, sum(a.revenue) as "store_business in $"from
(SELECT film_id, title, rental_duration, rental_duration*rental_rate as revenue
FROM film group by title ORDER BY rental_duration DESC) as a inner join
(select film_id, count(film_id) as film_total, store_id from inventory group by film_id) as b on a.film_id = b.film_id group by store_id;



#7g
SELECT 
    d.store_id, d.address, d.city, e.country
FROM
    ((SELECT 
        b.store_id, b.address, c.city, c.country_id
    FROM
        ((SELECT 
        s.store_id, a.address, a.city_id
    FROM
        (store AS s
    INNER JOIN (SELECT 
        address, address_id, city_id
    FROM
        address) AS a ON a.address_id = s.address_id)) AS b
    INNER JOIN (SELECT 
        country_id, city_id, city
    FROM
        city) AS c ON c.city_id = b.city_id)) AS d
    INNER JOIN (SELECT 
        country_id, country
    FROM
        country) AS e ON e.country_id = d.country_id);
        
#7h
SELECT 
    cat.name, SUM(amount) AS amt
FROM
    category cat
        INNER JOIN
    film_category fcat ON cat.category_id = fcat.category_id
        INNER JOIN
    inventory inv ON inv.film_id = fcat.film_id
        INNER JOIN
    rental ren ON ren.inventory_id = inv.inventory_id
        INNER JOIN
    payment pay ON pay.rental_id = ren.rental_id
GROUP BY cat.name
ORDER BY amt DESC
LIMIT 5;

#8a
create view TOP_five_GenreList as
SELECT 
    cat.name, SUM(amount) AS amt
FROM
    category cat
        INNER JOIN
    film_category fcat ON cat.category_id = fcat.category_id
        INNER JOIN
    inventory inv ON inv.film_id = fcat.film_id
        INNER JOIN
    rental ren ON ren.inventory_id = inv.inventory_id
        INNER JOIN
    payment pay ON pay.rental_id = ren.rental_id
GROUP BY cat.name
ORDER BY amt DESC
LIMIT 5;

#8b
select * from TOP_five_GenreList

#8c
drop view if exists Top_five_GenreList

--









 



