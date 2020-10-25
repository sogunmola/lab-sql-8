USE sakila;
/* 1) Rank films by length
*/
SELECT film_id, title, length, dense_rank() OVER (ORDER BY length desc) as length_rank 
FROM film;

/* 2) Rank films by length within the rating category.
*/
SELECT film_id, rating,title, length, dense_rank() OVER (PARTITION BY rating ORDER BY length) as rating_length_rank
FROM film
GROUP BY rating, title;

/* 3) Rank languages by the number of films (as original language).
*/
SELECT l.name, COUNT(f.film_id) as Number_of_films, 
DENSE_RANK() OVER (PARTITION BY l.name) as 'RANK'
FROM film f
JOIN language l ON l.language_id = f.language_id
GROUP BY l.name;

/* 4) Rank categories by the number of films.
*/
SELECT c.name, COUNT(f.film_id) AS ttl_films, 
DENSE_RANK() OVER (ORDER BY COUNT(f.film_id) DESC) AS 'RANK' 
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.name;

/* 5) Which actor has appeared in the most films?
*/
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.actor_id) AS ttl_films 
FROM film_actor fa
JOIN actor a ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY ttl_films DESC
LIMIT 1;

/* 6) Most active customer.
*/
SELECT cu.customer_id, cu.first_name, cu.last_name, COUNT(r.rental_id) AS ttl_rentals
FROM rental r
JOIN customer cu ON cu.customer_id = r.customer_id
GROUP BY cu.customer_id
ORDER BY ttl_rentals DESC
LIMIT 1;

/* 7) Most rented film
*/
SELECT f.film_id, i.inventory_id, f.title, COUNT(r.rental_id) AS ttl_rented 
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY f.film_id
ORDER BY ttl_rented DESC
LIMIT 1;
