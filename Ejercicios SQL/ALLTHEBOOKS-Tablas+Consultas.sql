drop table Client cascade constraints;
drop table Orders cascade constraints;
drop table Author cascade constraints;
drop table Author_Book cascade constraints;
drop table Book cascade constraints;
drop table Books_Order cascade constraints;

create table Client
(IdClient CHAR(10) PRIMARY KEY,
 Name VARCHAR(25) NOT NULL,
 Address VARCHAR(60) NOT NULL,
 NumCC CHAR(16) NOT NULL);
 
create table Orders
(IdOrder CHAR(10) PRIMARY KEY,
 IdClient CHAR(10) NOT NULL REFERENCES Client on delete cascade,
 DateOrder DATE NOT NULL,
 DateExped DATE);

create table Author
( idAuthor NUMBER PRIMARY KEY,
  Name VARCHAR(25));

create table Book
(ISBN CHAR(15) PRIMARY KEY,
Title VARCHAR(60) NOT NULL,
A�o CHAR(4) NOT NULL,
PurchasePrice NUMBER(6,2) DEFAULT 0,
SalePrice NUMBER(6,2) DEFAULT 0);

create table Author_Book
(ISBN CHAR(15),
Author NUMBER,
CONSTRAINT alA_PK PRIMARY KEY (ISBN, Author),
CONSTRAINT BookA_FK FOREIGN KEY (ISBN) REFERENCES Book on delete cascade,
CONSTRAINT AuthorA_FK FOREIGN KEY (Author) REFERENCES Author);

create table Books_Order(
ISBN CHAR(15),
IdOrder CHAR(10),
amount NUMBER(3) CHECK (amount >0),
CONSTRAINT lpB_PK PRIMARY KEY (ISBN, idOrder),
CONSTRAINT BookB_FK FOREIGN KEY (ISBN) REFERENCES Book on delete cascade,
CONSTRAINT pedidoB_FK FOREIGN KEY (IdOrder) REFERENCES Orders on delete cascade);

insert into Client values ('0000001','James Smith', 'Picadilly 2','1234567890123456');
insert into Client values ('0000002','Laura Jones', 'Holland Park 13', '1234567756953456');
insert into Client values ('0000003','Peter Doe', 'High Street 42', '1237596390123456');
insert into Client values ('0000004','Rose Johnson', 'Notting Hill 46', '4896357890123456');
insert into Client values ('0000005','Joseph Clinton', 'Leicester Square 1', '1224569890123456');
insert into Client values ('0000006','Betty Fraser', 'Whitehall 32', '2444889890123456' );


insert into Orders values ('0000001P','0000001', TO_DATE('01/12/2011'),TO_DATE('03/12/2011'));
insert into ORDERS values ('0000002P','0000001', TO_DATE('01/12/2011'),null);
insert into Orders values ('0000003P','0000002', TO_DATE('02/12/2011'),TO_DATE('03/12/2011'));
insert into Orders values ('0000004P','0000004', TO_DATE('02/12/2011'),TO_DATE('05/12/2011'));
insert into Orders values ('0000005P','0000005', TO_DATE('03/12/2011'),TO_DATE('03/12/2011'));
insert into Orders values ('0000006P','0000003', TO_DATE('04/12/2011'),null);

insert into Author values (1,'Jane Austin');
insert into Author values (2,'George Orwell');
insert into Author values (3,'J.R.R Tolkien');
insert into Author values (4,'Antoine de Saint-Exup�ry');
insert into Author values (5,'Bram Stoker');
insert into Author values (6,'Plato');
insert into Author values (7,'Vladimir Nabokov');

insert into Book values ('8233771378567', 'Pride and Prejudice', '2008', 9.45, 13.45);
insert into Book values ('1235271378662', '1984', '2009', 12.50, 19.25);
insert into Book values ('4554672899910', 'The Hobbit', '2002', 19.00, 33.15);
insert into Book values ('5463467723747', 'The Little Prince', '2000', 49.00, 73.45);
insert into Book values ('0853477468299', 'Dracula', '2011', 9.45, 13.45);
insert into Book values ('1243415243666', 'The Republic', '1997', 10.45, 15.75);
insert into Book values ('0482174555366', 'Lolita', '1998', 4.00, 9.45);


insert into Author_Book values ('8233771378567',1);
insert into Author_Book values ('1235271378662',2);
insert into Author_Book values ('4554672899910',3);
insert into Author_Book values ('5463467723747',4);
insert into Author_Book values ('0853477468299',5);
insert into Author_Book values ('1243415243666',6);
insert into Author_Book values ('0482174555366',7);

insert into Books_Order values ('8233771378567','0000001P', 1);
insert into Books_Order values ('5463467723747','0000001P', 2);
insert into Books_Order values ('0482174555366','0000002P', 1);
insert into Books_Order values ('4554672899910','0000003P', 1);
insert into Books_Order values ('8233771378567','0000003P', 1);
insert into Books_Order values ('1243415243666','0000003P', 1);
insert into Books_Order values ('8233771378567','0000004P', 1);
insert into Books_Order values ('4554672899910','0000005P', 1);
insert into Books_Order values ('1243415243666','0000005P', 1);
insert into Books_Order values ('5463467723747','0000005P', 3);
insert into Books_Order values ('8233771378567','0000006P', 5); 


--ej 1
select ISBN, Title, A�o, Name
from Book NATURAL JOIN Author_Book NATURAL JOIN Author
WHERE Author_Book.AUTHOR = Author.idAuthor
ORDER BY A�o;
--ej2
select Title, A�o
from Book 
where A�o < 2000;
--ej3
select DISTINCT IdClient, Name
from Client NATURAL JOIN Orders;
--ej4
select IdClient, Name
from Client NATURAL JOIN Orders NATURAL JOIN BOOKS_ORDER
where ISBN = 4554672899910;
--EJ5
select IdClient, Name, Title, ISBN
from Client NATURAL JOIN Orders NATURAL JOIN Books_Order NATURAL JOIN Book
where Name LIKE '%Jo%';
--ej6
select DISTINCT IdClient, Name
from Client NATURAL JOIN Orders NATURAL JOIN BOOKS_ORDER NATURAL JOIN Book
where SalePrice > 10;
--ej7
select IdClient, Name, DateOrder
from Client NATURAL JOIN Orders
where DateExped is NULL;
--ej 8

--1: gente que ha comprado libros con coste mayor que 10
select DISTINCT IdClient
from Client natural join ORDERS natural join Books_order natural join Book
where salePrice > 10;
--2: queremos lo contrario:
select DISTINCT IdClient
from Client
WHERE IdClient NOT IN ( select DISTINCT IdClient
                        from Client natural join ORDERS natural join Books_order natural join Book
                        where salePrice > 10);

--ej 9
select DISTINCT isbn, Title
from Book
where SalePrice > 30 Or A�o < 2000;

--ej 10
select IdClient, Name
from Client NATURAL JOIN Orders
group by IdClient, Name, DateOrder
having count(*) > 1;

--ej 11
select Title, SUM(amount)
from Book NATURAL JOIN BOOKS_ORDER
group by Title;

--ej 12
select Name, IdClient, SUM(SalePrice*amount)
from Client NATURAL JOIN Orders NATURAL JOIN Books_Order NATURAL JOIN Book
group by Name, IdClient;

--ej 13
select SUM(SalePrice*amount) - SUM(PurchasePrice*amount)
from Book NATURAL JOIN Books_Order;

--ej 14
select DateOrder, SUM(SalePrice*amount)
from Books_order NATURAL JOIN Orders NATURAL JOIN Book
where DateExped is NULL and DateOrder >= '01/12/2011'
group by DateOrder
order by DateOrder;

--ej 15
select IdOrder, SUM(amount*SalePrice)
from Books_Order NATURAL JOIN Book
group by IdOrder
having SUM(amount*SalePrice) > 100;

--ej 16
select IdOrder, sum(amount*salePrice)
from Books_Order NATURAL JOIN Book
group by IdOrder
having COUNT(*) > 1;

--ej 17
select IdOrder, sum(amount*salePrice)
from Books_Order NATURAL JOIN Book
group by IdOrder
having sum(amount) > 4;

-- ej 18
select Title
from Book 
where SalePrice = (select MAX(SalePrice)
                  from Book);

-- ej 19
--1: estos son los libros cuyas copias dan cada una un beneficio mayor que 5
select ISBN
from Book NATURAL JOIN Books_Order
where SalePrice - PurchasePrice > 5;
--2: quiero lo contrario
select Title, ISBN
from Book
where ISBN not in ( select ISBN
                    from Book NATURAL JOIN Books_Order
                    where SalePrice - PurchasePrice >= 5);
--EJ 20
select DISTINCT IdClient, Name
from Client NATURAL JOIN ORDERS NATURAL JOIN BOOKS_ORDER
where amount > 1;

