#1. Creamos un database llamado house_price_regression
create database house_price_regression;

use house_price_regression;

# 2 Creamos la tabla house_price_data con el mismo numero que el csv

drop table if exists house_price_data;

create table house_price_data (
	id varchar(30),
	`date` varchar(15),
    bedrooms int,
    bathrooms float,
    sqft_living int,
    sqft_lot int,
    floors float,
    waterfront int,
    `view` int,
    `condition` int,
    grade int,
    sqft_above int,
    sqft_basement int,
    yr_built int,
    yr_renovated int,
    zipcode int,
    lat float,
    `long` float,
    sqft_living15 int,
    sqft_lot15 int,
    price int
    );
    
# 3 vamos a importar el csv 

# 4 Selec all y comprobar si se ha cargado correctamente

select * from house_price_data;

-- 5 Usa el comando alter table command para dropear la column date de la databased.

alter table house_price_data
drop date;
select * from house_price_data
limit 10;

-- 6. usar sql query par aencontrar cuantas columnas hay.
select count(*)
from house_price_data;

-- 7. ahora vamos a encontrar los valores unicos de las columnas categorical:
-- Cuantos valores unicos para las bedrooms
select distinct bedrooms from house_price_data;

-- Cuantos valores unicos para las bathrooms?
select distinct bathrooms 
from house_price_data;

-- Cuantos valores unicos para las floors?
select distinct floors 
from house_price_data;

-- Cuantos valores unicos para las condition?
select distinct `condition` 
from house_price_data;

-- Cuantos valores unicos para las grade?
select distinct `grade` 
from house_price_data;

-- 8. Ordena la data en orden descendente por el precio de las casas y solo devuelve los 10IDs de las más caras.
select id, price from house_price_data
order by price desc
limit 10;


-- 9.Precio medio
select avg(price) from house_price_data;

-- 10. En este ejercicio utilizaremos la agrupación simple por para comprobar las propiedades de algunas de las variables categóricas de nuestros datos
-- ¿Cuál es el precio medio de las viviendas agrupadas por dormitorios? 
-- El resultado devuelto debe tener sólo dos columnas, dormitorios y Media de los precios. Utilice un alias para cambiar el nombre de la segunda columna.
select distinct bedrooms, round(avg(price),0) as AvgPrice from house_price_data
group by bedrooms
order by bedrooms asc;

-- ¿Cuál es el promedio de sqft_living de las casas agrupadas por dormitorios? 
-- El resultado devuelto debe tener sólo dos columnas, dormitorios y Promedio del sqft_living. Utilice un alias para cambiar el nombre de la segunda columna.
select distinct bedrooms, round(avg(sqft_living),0) as avgSqftLiving from house_price_data
group by bedrooms
order by bedrooms asc;

-- ¿Cuál es el precio medio de las casas con frente de agua y sin frente de agua? 
-- El resultado devuelto debe tener sólo dos columnas, frente al mar y Media de los precios. Utilice un alias para cambiar el nombre de la segunda columna.
select distinct waterfront, round(avg(price),0) as avg_price from house_price_data
group by waterfront
order by waterfront asc;

-- ¿Existe alguna correlación entre las columnas condición y grado?  Puedes analizarlo agrupando los datos por una de las variables y luego agregando los resultados de la otra columna. 
-- Comprueba visualmente si existe una correlación positiva, negativa o ninguna entre las variables.
select grade, avg(`condition`) as avg_condition from house_price_data 
group by grade
order by grade asc; 
select `condition`, avg(grade) as avg_grade from house_price_data 
group by `condition`
order by `condition` asc; 
-- no hay una correlación clara para las calificaciones, ya que todas ienen una condición media en torno a 3. En las casas con un estado superior a 3, la nota media es superior a 7. 

-- 11. Uno de los clientes sólo está interesado en las siguientes casas:
-- Número de dormitorios 3 ó 4
-- Baños más de 3
-- Una planta
-- Sin paseo marítimo
-- Condición debe ser 3 por lo menos
-- Grado debe ser 5 por lo menos
-- Precio menos de 300000


select id, bedrooms, bathrooms, floors, waterfront, `condition`, grade, price from house_price_data 
where bedrooms in (3,4)
and bathrooms > 3 
and floors = 1 
and waterfront = 0
and `condition` >= 3
and grade > 4
and price < 300000;


-- 12. Su jefe quiere averiguar la lista de propiedades cuyos precios son dos veces superiores a la media de todas las propiedades de la base de datos. 
-- Escriba una consulta para mostrarle la lista de dichas propiedades. Puede que necesites utilizar una subconsulta para este problema.

select id, price from house_price_data
where price > (
	select avg(price) * 2 from house_price_data);

-- 13. Dado que esto es algo que interesa regularmente a la alta dirección, cree una vista de la misma consulta.
create view houses_price_above_double_avg as 
select id, price from house_price_data
where price > (
	select avg(price) * 2 from house_price_data);

-- 14. La mayoría de los clientes están interesados en viviendas de tres o cuatro dormitorios. ¿Cuál es la diferencia entre los precios medios de las viviendas de tres y cuatro dormitorios?
select (
select round(avg(price),2) from house_price_data
where bedrooms = 4
)-(
select round(avg(price),2) from house_price_data
where bedrooms = 3) as price_diff;

-- 15. ¿Cuáles son las distintas ubicaciones en las que hay inmuebles disponibles en su base de datos? (códigos postales distintos)

select distinct zipcode as locations
from house_price_data;

-- 16.Mostrar la lista de todos los inmuebles renovados
select id, yr_renovated from house_price_data
where yr_renovated > 0;

-- 17. Facilite los datos de la undécima propiedad más cara de su base de datos.
select * from house_price_data
order by price desc
limit 1 offset 10;
