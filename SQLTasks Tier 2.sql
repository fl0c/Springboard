/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/*--------------------------------------------------------------------------------------*/
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

/* Q1 Answer:
SELECT name FROM `Facilities` WHERE `membercost`> 0;

Output:
name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court*/

/*--------------------------------------------------------------------------------------*/

/* Q2: How many facilities do not charge a fee to members? */

/* Q2 Answer:
SELECT COUNT(DISTINCT name) FROM `Facilities` WHERE `membercost` =0;

Output: 4 */

/*--------------------------------------------------------------------------------------*/

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

/* Q3 Answer:
SELECT facid, name, membercost, `monthlymaintenance` FROM `Facilities` 
WHERE `membercost` > 0
AND `membercost` < 0.2*`monthlymaintenance`;

Output:
facid	name			membercost	monthlymaintenance
0	Tennis Court 1		5.0		200
1	Tennis Court 2		5.0		200
4	Massage Room 1		9.9		3000
5	Massage Room 2		9.9		3000
6	Squash Court		3.5		80
*/

/*--------------------------------------------------------------------------------------*/

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

/* Q4 Answer:
SELECT * FROM `Facilities` 
WHERE `facid` = 1 OR `facid` = 5;

SELECT * FROM `Facilities` 
WHERE `facid` IN (1,5);

Output:
facid		name			membercost	guestcost	initialoutlay	monthlymaintenance
1		Tennis Court 2		5.0		25.0		8000		200
5		Massage Room 2		9.9		80.0		4000		3000
*/

/*--------------------------------------------------------------------------------------*/

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

/* Q5 Answer:
SELECT `name`,`monthlymaintenance` ,
CASE
    WHEN `monthlymaintenance` < 100 THEN "cheap"
    ELSE "expensive"
END
FROM `Facilities`;
*/

/*--------------------------------------------------------------------------------------*/
/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

/* Q6 Answer:
SELECT firstname, surname, joindate
FROM Members
ORDER BY joindate DESC
#LIMIT 5;

*/

/*--------------------------------------------------------------------------------------*/

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

/* Q7 Answer:
SELECT DISTINCT (m.firstname || ' ' || m.surname) as fullname, f.name
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE b.facid in (0,1)
Order by fullname;

*/

/*--------------------------------------------------------------------------------------*/


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name, (firstname || ' ' || surname) as name,
	(CASE WHEN b.memid != 0 AND slots * membercost > 30 THEN slots * membercost
	WHEN b.memid = 0 AND slots * guestcost > 30 THEN slots * guestcost
	END) as cost
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE starttime LIKE '2012-09-14%'
AND (b.memid != 0 AND slots * membercost > 30 OR
b.memid = 0 AND slots * guestcost > 30)
ORDER BY cost DESC
;


/*--------------------------------------------------------------------------------------*/


/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT f.name, (firstname || ' ' || surname) as name,
	(CASE WHEN b.memid != 0 AND slots * membercost > 30 THEN slots * membercost
	WHEN b.memid = 0 AND slots * guestcost > 30 THEN slots * guestcost
	END) as cost
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE starttime LIKE '2012-09-14%'
AND (b.memid != 0 AND slots * membercost > 30 OR
b.memid = 0 AND slots * guestcost > 30)
ORDER BY cost DESC
;

/*--------------------------------------------------------------------------------------*/

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

import sqlite3
connection = sqlite3.connect('sqlite_db_pythonsqlite.db')
print("Opened database successfully")
cursor = connection.cursor()
#df = pd.read_sql_query(query, connection)
#connection.close()


QUESTIONS:
/*--------------------------------------------------------------------------------------*/

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT f.name,
	SUM(CASE WHEN b.memid != 0 THEN slots * membercost
	WHEN b.memid = 0 THEN slots * guestcost
	END) as revenue
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
GROUP BY f.facid 
ORDER BY revenue DESC
;

rows = cursor.execute("SELECT f.name, SUM(CASE WHEN b.memid != 0 THEN slots * membercost WHEN b.memid = 0 THEN slots * guestcost END) as revenue FROM Bookings as b LEFT JOIN Facilities as f ON b.facid = f.facid LEFT JOIN Members as m  ON b.memid = m.memid GROUP BY f.facid ORDER BY revenue DESC").fetchall()
print(rows)

/*--------------------------------------------------------------------------------------*/

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


SELECT (m1.surname || ' ' || m1.firstname) as member, (m2.surname || ' ' || m2.firstname) as reco_mem
FROM Members as m1
LEFT JOIN Members as m2
ON m1.recommendedby = m2.memid
ORDER BY member

rows = cursor.execute("SELECT (m1.surname || ' ' || m1.firstname) as member, (m2.surname  || ' ' ||  m2.firstname) as reco_mem FROM Members as m1 LEFT JOIN Members as m2 ON m1.recommendedby = m2.memid ORDER BY member").fetchall()
print(rows)

/*--------------------------------------------------------------------------------------*/

/* Q12: Find the facilities with their usage by member, but not guests */

SELECT f.name, (firstname || ' ' || surname) as name,
	SUM(CASE WHEN b.memid != 0 THEN slots * 0.5
	END) as mem_hr_use
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE b.memid != 0
GROUP BY f.facid, b.memid
ORDER BY mem_hr_use DESC

rows = cursor.execute("SELECT f.name, (firstname || ' ' || surname) as name, SUM(CASE WHEN b.memid != 0 THEN slots * 0.5 END) as mem_hr_use FROM Bookings as b LEFT JOIN Facilities as f ON b.facid = f.facid LEFT JOIN Members as m ON b.memid = m.memid WHERE b.memid != 0 GROUP BY f.facid, b.memid ORDER BY mem_hr_use DESC").fetchall()
print(rows)

/*--------------------------------------------------------------------------------------*/

/* Q13: Find the facilities usage by month, but not guests */

SELECT f.name,MONTH(starttime), YEAR(starttime),
	SUM(CASE WHEN b.memid != 0 THEN slots * 0.5
	END) as mem_hr_use
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE b.memid != 0
GROUP BY f.facid, MONTH(starttime)
ORDER BY mem_hr_use DESC

/*--------------------------------------------------------------------------------------*/
