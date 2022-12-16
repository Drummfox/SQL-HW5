--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

select f.film_id, f.title, f.special_features 
from film f 
where f.special_features @>  array ['Behind the Scenes']



--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

select f.film_id, f.title, f.special_features 
from film f 
where f.special_features &&  array ['Behind the Scenes']

select f.film_id, f.title, f.special_features 
from film f 
where 'Behind the Scenes' = any(f.special_features)

select f.film_id, f.title, f.special_features 
from film f 
where  array_positions(f.special_features, 'Behind the Scenes') is not null



--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

with cte as (
select f.film_id, f.title, f.special_features 
from film f 
where f.special_features &&  array ['Behind the Scenes']
)
select c.customer_id, count(cte.film_id)
from cte
 join inventory i on cte.film_id = i.film_id 
 join rental r on i.inventory_id = r.inventory_id 
 join customer c on c.customer_id = r.customer_id 
 group by c.customer_id
 order by c.customer_id
 



--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

select c.customer_id, count(t.film_id)
 from
	(
	select f.film_id, f.title, f.special_features 
	from film f 
	where f.special_features &&  array ['Behind the Scenes']
	) t
 join inventory i on t.film_id = i.film_id 
 join rental r on i.inventory_id = r.inventory_id 
 join customer c on c.customer_id = r.customer_id 
 group by c.customer_id
 order by c.customer_id	



--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized  view task1 as 
 select c.customer_id, count(t.film_id)
 from
	(
	select f.film_id, f.title, f.special_features 
	from film f 
	where f.special_features &&  array ['Behind the Scenes']
	) t
 join inventory i on t.film_id = i.film_id 
 join rental r on i.inventory_id = r.inventory_id 
 join customer c on c.customer_id = r.customer_id 
 group by c.customer_id
 order by c.customer_id	
 --with no data
 
 refresh materialized view task1



--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:

--1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, 
--   поиск значения в массиве происходит  
одинаково кроме использования метода с any  он дольше
--2. какой вариант вычислений работает быстрее: 
--   с использованием CTE или с использованием подзапроса 
одинаково 720.77
на 10 версии подзапрос работае быстрее 





--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день




