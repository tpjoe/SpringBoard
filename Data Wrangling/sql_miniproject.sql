/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT * FROM Facilities
WHERE membercost > 0.0
/* A1: name
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court */


/* Q2: How many facilities do not charge a fee to members? */
SELECT * FROM Facilities
WHERE membercost = 0.0
/* A2: 4 */


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT  facid AS fac_id,
		name AS fac_name,
		membercost AS membership_cost,
		monthlymaintenance AS monthly_maintenance_cost
	FROM Facilities
WHERE membercost < monthlymaintenance * 0.2
/* fac_id 	fac_name 	membership_cost 	monthly_maintenance_cost 	
0 	Tennis Court 1 	5.0 	200
1 	Tennis Court 2 	5.0 	200
2 	Badminton Court 	0.0 	50
3 	Table Tennis 	0.0 	10
4 	Massage Room 1 	9.9 	3000
5 	Massage Room 2 	9.9 	3000
6 	Squash Court 	3.5 	80
7 	Snooker Table 	0.0 	15
8 	Pool Table 	0.0 	15*/


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT  * FROM Facilities
WHERE facid IN ('1', '5')
/*facid 	name 	membercost 	guestcost 	initialoutlay 	monthlymaintenance 	
1 	Tennis Court 2 	5.0 	25.0 	8000 	200
5 	Massage Room 2 	9.9 	80.0 	4000 	3000*/


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT name AS fac_name, monthlymaintenance AS monthly_maintenance_cost,
CASE WHEN monthlymaintenance > 100 THEN 'expensive' ELSE 'cheap' END AS facility_cost
FROM Facilities
/* fac_name 	monthly_maintenance_cost 	facility_cost 	
Tennis Court 1 	200 	expensive
Tennis Court 2 	200 	expensive
Badminton Court 	50 	cheap
Table Tennis 	10 	cheap
Massage Room 1 	3000 	expensive
Massage Room 2 	3000 	expensive
Squash Court 	80 	cheap
Snooker Table 	15 	cheap
Pool Table 	15 	cheap*/


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname, surname, joindate FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members)
/*firstname 	surname 	joindate 	
Darren 	Smith 	2012-09-26 18:08:45*/


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT Facilities.name as court,
CONCAT(Members.surname, ', ', Members.firstname) AS member_name 
FROM Bookings
	JOIN Facilities
		ON Bookings.facid = Facilities.facid
	JOIN Members
		ON Bookings.memid = Members.memid
WHERE Bookings.memid != 0 AND Facilities.name LIKE 'TENNIS COURT%'
GROUP BY 1,2
ORDER BY 2
/* court 	member_name 	
Tennis Court 1 	Bader, Florence
Tennis Court 2 	Bader, Florence
Tennis Court 2 	Baker, Anne
Tennis Court 1 	Baker, Anne
Tennis Court 2 	Baker, Timothy
Tennis Court 1 	Baker, Timothy
Tennis Court 1 	Boothe, Tim
Tennis Court 2 	Boothe, Tim
Tennis Court 2 	Butters, Gerald
Tennis Court 1 	Butters, Gerald
Tennis Court 1 	Coplin, Joan
Tennis Court 1 	Crumpet, Erica
Tennis Court 2 	Dare, Nancy
Tennis Court 1 	Dare, Nancy
Tennis Court 1 	Farrell, David
Tennis Court 2 	Farrell, David
Tennis Court 1 	Farrell, Jemima
Tennis Court 2 	Farrell, Jemima
Tennis Court 1 	Genting, Matthew
Tennis Court 2 	Hunt, John
Tennis Court 1 	Hunt, John
Tennis Court 2 	Jones, David
Tennis Court 1 	Jones, David
Tennis Court 1 	Jones, Douglas
Tennis Court 1 	Joplette, Janice
Tennis Court 2 	Joplette, Janice
Tennis Court 2 	Owen, Charles
Tennis Court 1 	Owen, Charles
Tennis Court 1 	Pinker, David
Tennis Court 2 	Purview, Millicent*/


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT CONCAT(mems.surname, ', ', mems.firstname) AS member, facs.name AS facility,
CASE 
	WHEN mems.memid =0
		THEN bks.slots * facs.guestcost
	ELSE bks.slots * facs.membercost
	END AS cost
FROM  `Members` mems
	JOIN  `Bookings` bks ON mems.memid = bks.memid
	JOIN  `Facilities` facs ON bks.facid = facs.facid
	WHERE bks.starttime >=  '2012-09-14' AND bks.starttime <  '2012-09-15' 
AND ((mems.memid =0 AND bks.slots * facs.guestcost >30)
	OR (mems.memid !=0 AND bks.slots * facs.membercost >30))
ORDER BY cost DESC 
LIMIT 0 , 1000
/*member 	facility 	cost Descending 	
GUEST, GUEST 	Massage Room 2 	320.0
GUEST, GUEST 	Massage Room 1 	160.0
GUEST, GUEST 	Massage Room 1 	160.0
GUEST, GUEST 	Massage Room 1 	160.0
GUEST, GUEST 	Tennis Court 2 	150.0
GUEST, GUEST 	Tennis Court 2 	75.0
GUEST, GUEST 	Tennis Court 1 	75.0
GUEST, GUEST 	Tennis Court 1 	75.0
GUEST, GUEST 	Squash Court 	70.0
Farrell, Jemima 	Massage Room 1 	39.6
GUEST, GUEST 	Squash Court 	35.0
GUEST, GUEST 	Squash Court 	35.0*/


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT member, facility, cost
FROM (

SELECT CONCAT(mems.surname, ', ', mems.firstname) AS member, facs.name AS facility, 
CASE 
	WHEN mems.memid =0
		THEN bks.slots * facs.guestcost
	ELSE bks.slots * facs.membercost
	END AS cost
FROM  `Members` mems
	JOIN  `Bookings` bks ON mems.memid = bks.memid
	INNER JOIN  `Facilities` facs ON bks.facid = facs.facid
	WHERE bks.starttime >=  '2012-09-14' AND bks.starttime < '2012-09-15') AS bookings
	WHERE cost >30
ORDER BY cost DESC
/*member 	facility 	cost 	
GUEST, GUEST 	Massage Room 2 	320.0
GUEST, GUEST 	Massage Room 1 	160.0
GUEST, GUEST 	Massage Room 1 	160.0
GUEST, GUEST 	Massage Room 1 	160.0
GUEST, GUEST 	Tennis Court 2 	150.0
GUEST, GUEST 	Tennis Court 2 	75.0
GUEST, GUEST 	Tennis Court 1 	75.0
GUEST, GUEST 	Tennis Court 1 	75.0
GUEST, GUEST 	Squash Court 	70.0
Farrell, Jemima 	Massage Room 1 	39.6
GUEST, GUEST 	Squash Court 	35.0
GUEST, GUEST 	Squash Court 	35.0*/

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
SELECT Facilities.name AS facility,

SUM(CASE 
	WHEN Bookings.memid = 0 
		THEN Facilities.guestcost * Bookings.slots 
	ELSE Facilities.membercost * Bookings.slots 
	END) AS revenue
FROM Facilities
	JOIN Bookings
		ON Facilities.facid = Bookings.facid
GROUP BY 1
HAVING revenue < 1000
ORDER BY revenue DESC
/* facility 	revenue Descending 	
Pool Table 	270.0
Snooker Table 	240.0
Table Tennis 	180.0*/
