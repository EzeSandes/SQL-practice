-- Q1: Find the names of all students who are friends with someone named Gabriel. 
        
# Se entiende mejor si se lee del ultimo parentesis al primero, de Gabriel hacia atras
SELECT DISTINCT name
FROM highschooler
WHERE id IN (	SELECT id1
				FROM friend
				WHERE id2 IN (	SELECT id
								FROM highschooler
                                WHERE name = 'Gabriel'
							 )
			)
;

-- Otra forma
 SELECT DISTINCT name
 FROM Highschooler
 JOIN Friend
 ON Friend.ID1 = Highschooler.ID
 WHERE ID2 IN	(
					SELECT id
					FROM Highschooler
					WHERE Highschooler.name = 'Gabriel'
				);

-- Q2: For every student who likes someone 2 or more grades younger than themselves, 
-- return that student's name and grade, and the name and grade of the student they like. 

select distinct sName, sGrade, lName, lGrade
from (
		select h1.name as sName, h1.grade sGrade, h2.name as lName, h2.grade as lGrade, h1.grade - h2.grade as gradeDifference 
		from Highschooler h1, Likes, Highschooler h2
		where h1.ID=ID1 and h2.ID=ID2 # QUIEN DIO LIKE A QUIEN...
     )
where gradeDiff>1;

--Otra forma
SELECT h1.name AS Name, h1.grade AS GradeH1, h2.name AS Name2, h2.grade AS Grade2 
FROM Highschooler h1, Highschooler h2, Likes l
WHERE	h1.ID = l.ID1 
		AND l.ID2 = h2.ID
		AND h1.grade - h2.grade >= 2;


-- Q3: For every pair of students who both like each other, return the name and grade of both students. 
	-- Include each pair only once, with the two names in alphabetical order.


SELECT DISTINCT h1.Name AS Name_Est1, h1.grade AS Grade_Est1, h2.Name AS Name_Est2, h2.Name AS Grade_Est1
FROM highschooler h1, highschooler h2, likes l1, likes l2
WHERE 	l1.id1 = l2.id2 AND l2.id1 = l1.id2 #Likes que dieron y recibieron
		AND l1.ID1 = h1.ID AND l1.id2 = h2.id
        AND h2.name > h1.name # Esta condicion es para que no se repita el par. Si lo hago con esto, se repite pero cambiado de orden los likes, porque se dieron
								# likes entre ellos
ORDER BY Name_Est1 DESC, Name_Est2 DESC;


-- Q4: Find all students who do not appear in the Likes table (as a student who likes or is liked) 
		-- and return their names and grades. Sort by grade, then by name within each grade. 

SELECT name, grade
FROM Highschooler
WHERE ID NOT IN	(
					SELECT ID1
					FROM Likes
					UNION
					SELECT ID2
					FROM Likes
				)
ORDER BY grade, name;

-- --Q5 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table)
		-- , return A and B's names and grades.

select distinct H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1, Likes, Highschooler H2
where H1.ID = Likes.ID1 and Likes.ID2 = H2.ID and H2.ID not in (select ID1 from Likes);

SELECT h1.name AS Name1, h1.grade AS Grade1, h2.name AS Name2, h2.grade AS Grade2
FROM Highschooler h1
JOIN Likes l
ON l.ID1 = h1.ID
JOIN Highschooler h2
ON h2.ID = l.ID2
WHERE l.ID2 NOT IN (SELECT ID1 FROM Likes);

--  Q6 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 

SELECT DISTINCT Name, grade
FROM Highschooler
WHERE id NOT IN
				(	SELECT id1
					FROM Highschooler h1, Highschooler h2, friend f1
                    WHERE h1.id = f1.id1 AND f1.id2 = h2.id AND h1.grade <> h2.grade
				)
ORDER BY grade, name;

-- --Q7: For each student A who likes a student B where the two are not friends, find if they have a friend C in common 
	-- (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Likes, Highschooler H2, Highschooler H3, Friend F1, Friend F2
where 	H1.ID = Likes.ID1 and Likes.ID2 = H2.ID # Me quedo con una fila de quien A le dio Like a B
		and H2.ID not in (	select ID2 from Friend where ID1 = H1.ID	) # y con quien B no se encuentra en la lista de amigos de A
        and H1.ID = F1.ID1 
        and F1.ID2 = H3.ID 
        and H3.ID = F2.ID1 # Amigo en comun
        and F2.ID2 = H2.ID;

-- --Q8: Find the difference between the number of students in the school and the number of different first names. 

select st.sNum-nm.nNum from 
(select count(*) as sNum from Highschooler) as st,
(select count(distinct name) as nNum from Highschooler) as nm;

-- --Q9: Find the name and grade of all students who are liked by more than one other student. 

SELECT h.name, h.grade
FROM highschooler h
JOIN likes l
ON l.id1 = h.id
GROUP BY h.id
HAVING COUNT(*) > 1;

select name, grade 
from (select ID2, count(ID2) as numLiked from Likes group by ID2), Highschooler
where numLiked>1 and ID2=ID;



