--ex1:
--a)
create or replace procedure CheckNumRoutes (reference Contracts.Ref%type)
IS
  realRoutes Contracts.NumRoutes%type;
  --nameOrganization Contracts.Organization%type;
BEGIN

  select count(*)--, Contracts.Organization
  into realRoutes--, nameOrganization
  from /**Contracts,*/ Routes
  where /**Contracts.Ref = reference and*/ Routes.Ref = reference;
  --group by Contracts.Organization;
  
 update Contracts
  set NumRoutes = realRoutes
  where ref = reference;
  
  DBMS_OUTPUT.PUT_LINE('Name of the organization: ' || Contracts.Organization);
  DBMS_OUTPUT.PUT_LINE('Number of asociated routes: ' || realRoutes);
EXCEPTION
  when NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('Error- esta referencia no tiene rutas!!');
END;

--ex2

--b)
create or replace procedure ex2b 
is
department Departments.CodDept%type;
numberOfSalaries NUMBER(4,0);
lastDepartment Departments.CodDept%type := '';

--declaramos un cursor ya que el resultado consta de varias lineas
cursor belowAverage is 
select CodDept, Count(*)
from Employees
where Salary < (select AVG(salary)
                from Employees)
group by CodDept;

begin

open belowAverage;

loop
fetch belowAverage into department, numberOfSalaries;
if (lastDepartment != department and numberOfSalaries > 0) then 
  DBMS_OUTPUT.PUT_LINE('Nombre del departamento: ' || department || numberOfSalaries);
  lastDepartment := department;
end if;
exit when belowAverage%NOTFOUND;
end loop;

close belowAverage;

end;

--3

create or replace procedure ex3a (name Revista.Nombre%type) is
issnR Revista.issn%type;
nombreAutor Autor.Nombre%type;
apellidoAutor Autor.Nombre%type;

cursor Autores is
select Autor.Nombre, Autor.Apellido
from Autor natural join Firma natural join Articulo, Revista
where ARTICULO.ISSNREVISTA = Revista.ISSN and Revista.Nombre = name;

begin

select issn
into issnR
from Revista
where Revista.Nombre = name;

dbms_OUTPUT.PUT_LINE('Datos de la revista: '|| issnR || name);

open Autores;

loop
fetch Autores into nombreAutor, apellidoAutor;
if Autores%FOUND then 
dbms_OUTPUT.PUT_LINE(nombreAutor || apellidoAutor);
else
dbms_OUTPUT.PUT_LINE('No hay autores');
end if;
exit when Autores%NOTFOUND;
end loop;

close Autores;
end;


--4
--a)
create or replace procedure ex4a (fecha DATE, CodigoOrig Aeropuerto.Codigo%type, 
                                  CodigoDest Aeropuerto.Codigo%type, Pass Billetes.Pasaporte%type) is
numeroDeVuelo Vuelo.numero%type := '-1';

begin

select Numero
into numeroDeVuelo
from Vuelo
where Origen = CodigoOrig and Destino = CodigoDest and Plazas > 1 and fecha = Vuelo.Fecha;

if numeroDeVuelo = '-1' then
  dbms_output.put_line('No hay vuelos disponibles');
else 
  insert into Billetes(Numero, Fecha) VALUES (numeroDeVuelo, Pass);
  
  update Ventas
  set Vendidos = Vendidos + 1
  where Numero = numeroDeVuelo;

  update Vuelo
  set Plazas = Plazas - 1
  where Numero = numeroDeVuelo;
  
end if;

end;
