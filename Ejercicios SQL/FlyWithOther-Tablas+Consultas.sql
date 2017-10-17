--ej1
SELECT employee.NAME, employee.EID, aircraft.name
FROM EMPLOYEE NATURAL JOIN CERTIFICATE NATURAL JOIN AIRCRAFT
WHERE aircraft.name LIKE '%Boeing%';

--ej2
select aid
from aircraft
where distance >= (select distance
                    from flight
                    where origin = 'Los Angeles' and destination = 'Chicago');
                    
--EJ3
select eid, employee.name
from employee natural join CERTIFICATE natural join aircraft
where distance = 3000 and NAME not in (select name
                                      from aircraft
                                      where name LIKE 'Boeing%');
--EJ4
select name, eid, salary
from employee
where salary = (select MAX(salary)
                from employee);
--ej5
select DISTINCT name, eid, COUNT(*)
from employee natural join certificate
GROUP BY name, eid
having count(*) = (select MAX(count(*))
                   from certificate
                   group by eid);

--ej6
select name, eid
from employee natural join certificate
group by name, eid
having count(*) >= 3;

--ej 7
--1: empleados que cobran más de 80000:
select eid
from employee
where salary > 80000;
--2: aviones que pueden manejar estos empleados:
select aircraft.name
from aircraft natural join certificate, employee
where certificate.eid = employee.eid 
group by aircraft.name
having employee.eid in (select eid
                        from employee
                        where salary > 80000);
--ej 8:
select eid, MAX(distance)
from employee natural join certificate, aircraft
where certificate.aid = aircraft.aid
group by eid
having count(*) > 3;

--ej 9:
--1: get the cheapier fligh from LA to HNLL
select MIN(price)
from flight
where origin = 'Los Angeles' and destination = 'Honolulu';
--2: List of pilots with less salary
select eid, name
from employee
where salary < (select MIN(price)
                from flight
                where origin = 'Los Angeles' and destination = 'Honolulu');
                
--ej 10:
--salario de todos:
select AVG(salary)
from employee;
--salario de los pilotos
select AVG(salary)
from employee natural join certificate;

--ej 11:
select name, salary
from employee
group by name, salary
having salary >= (select AVG(salary)
                from employee natural join certificate) AND name not in (select name
                                                                          from employee
                                                                          natural join certificate);
--ej 12:
select employee.name, eid
from employee natural join certificate, aircraft
where certificate.aid = aircraft.aid
group by employee.name, eid
having eid not in ( select eid
					from employee natural join certificate, aircraft
					where certificate.aid = aircraft.aid and aircraft.distance <= 1000); -- con esta sub consulta
					--seleccionamos los nombres de todos los que pueden pilotar aviones de distancia <= 1000
                           
						   
          
