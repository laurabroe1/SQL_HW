use sakila; 

-- 1a. You need a list of all the actors who have Display the first and last names of all actors from the table actor.

-- 1b. Display the first name and last name  of each actor in a single column in upper case letters. Name the column Actor Name. (alter table) 

select * from 
select * from actor; 
citycategory
select first_name, last_name from actor; 

select upper(concat(first_name, ' ' , last_name)) as "Actor Name" from actor 

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:

select last_name 
from actor 
where last_name like '%GEN%'; 

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select last_name, first_name 
from actor 
where last_name like '%LI%' 

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country
from country 
where country in
(
  select country 
  from country
  where country in ('Afghanistan', 'Bangladesh', 'China')
);

-- Add a middle_name column to the table actor. Position it between first_name and last_name. Change the data type of the middle_name column to blobs.
select first_name, last_name from actor; 
alter table actor
add column middle_name blob(25) after first_name;

select first_name, middle_name, last_name from actor;  

-- Now delete the middle_name column.

alter table actor drop column middle_name; 

-- List the last names of actors, as well as how many actors have that last name.

select count(last_name), last_name from actor group by last_name; 

-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*)
    FROM actor
    GROUP BY last_name
    HAVING COUNT(*) > 2
    
-- Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, Write a query to fix the record.
-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO 
-- was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

select * from actor; 

start transaction;
set autocommit = 0;   
update actor 
set first_name = "Groucho" 
where first_name = "Harpo"
rollback; 

-- You cannot locate the schema of the address table. Which query would you use to re-create it?

SELECT * FROM sakila.address;
 
-- Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

use sakila; 
select * from staff; 
select * from address; 

select staff.staff_id, staff.address_id, staff.first_name, staff.last_name, address.address
from staff 
inner join address on 
staff.address_id = address.address_id; 

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

select * from staff; 
select * from payment; 

select staff.staff_id, sum(payment.amount), payment.payment_date 
from staff 
inner join payment on 
staff.staff_id = payment.staff_id
where payment_date between '2005-08-01 00:00:00' and '2005-09-01 00:00:00'
group by staff.staff_id; 

-- List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join. --title, actor_id, film_id
select * from film; 
select * from film_actor; 

select title, count(actor_id)
from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by title;

-- How many copies of the film Hunchback Impossible exist in the inventory system? 
select * from film; 
select * from inventory; 

select * from film where title = "Hunchback Impossible"; -- film id 439 

select title, count(inventory_id)
from film
inner join inventory 
on film.film_id = inventory.film_id
where title= "Hunchback Impossible";

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
select * from customer; 
select * from payment; 

select customer.customer_id, customer.first_name, customer.last_name,  sum(payment.amount)
from customer
inner join payment
on customer.customer_id = payment.customer_id 
group by customer.customer_id
order by last_name ASC; -- List the customers alphabetically by last name

-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
use Sakila;

select * from film
where language_id in
(select language_id from language where name = "English" )
AND (title like "K%") 
OR (title like "Q%");

-- Use subqueries to display all actors who appear in the film Alone Trip.

select actor_id, last_name, first_name
from actor
where actor_id in
(
select actor_id from film_actor where film_id in 
		(select film_id from film where title = "Alone Trip")
)
;

--  need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
use sakila; 

select country_id, country, last_name, first_name, email
from country
left join customer
on country.country_id = customer.customer_id
where country = 'Canada'
group by email; 

-- Identify all movies categorized as family films.
select * from film_list; 

select FID, title, category
from film_list
where category = 'Family';


-- Display the most frequently rented movies in descending order.
use sakila; 

select * from film; 
select * from inventory;
select * from rental; 

select inventory.film_id, film.title, COUNT(rental.inventory_id)
from inventory 
inner join rental 
on inventory.inventory_id = rental.inventory_id
inner join film  
on inventory.film_id = film.film_id
group by rental.inventory_id
order by count(rental.inventory_id) desc;

-- Write a query to display how much business, in dollars, each store brought in.
select * from store;  
select * from staff; 
select * from payment; 

select store.store_id, sum(amount)
from store
inner join staff
on store.store_id = staff.store_id
inner join payment  
on payment.staff_id = staff.staff_id
group by store.store_id
order by sum(amount);

-- Write a query to display for each store its store ID, city, and country.
select * from store; 
select * from country; 
select * from city; 
select * from customer;

select s.store_id, city, country
from store s
inner join customer cu
on s.store_id = cu.store_id
inner join staff st
on s.store_id = st.store_id
inner join address a
ON cu.address_id = a.address_id
inner join city ci
on a.city_id = ci.city_id
inner join country coun
on ci.country_id = coun.country_id;

-- List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
update actor 
set first_name = "Harpo"
where first_name = "Groucho" 

select * from actor where first_name = "Harpo" and last_name = "Williams"

select name, sum(p.amount)
from category c
inner join film_category fc
inner join inventory i
on i.film_id = fc.film_id
inner join rental r
on r.inventory_id = i.inventory_id
inner join payment p
group by name
limit 5;


-- Change GROUCHO back to HARPO 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, 
-- change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)






 




