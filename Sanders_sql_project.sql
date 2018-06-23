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

/* ANSWER: The facilities that charge a fee to members include Tennis Court 1, Tennis Court 2, Massage Room1, Massage Room 2, and Squash Court. */
SELECT name
FROM `Facilities`
WHERE membercost >0



/* Q2: How many facilities do not charge a fee to members? */

/* ANSWER: 4 Facilities do not charge a few to members. */
SELECT COUNT( * )
FROM `Facilities` AS count
WHERE membercost = 0.0



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

/*ANSWER:  */
SELECT facid, name, membercost, monthlymaintenance
FROM `Facilities`
WHERE membercost < ( monthlymaintenance * .2 )
AND membercost > 0.0



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

/*ANSWER:  */
SELECT *
FROM `Facilities`
WHERE facid =1
OR facid =5



/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

/*ANSWER:  */
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance <100
THEN 'cheap'
ELSE 'expensive'
END AS cost_classification
FROM `Facilities`



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/*ANSWER:  */
SELECT firstname, surname, joindate
FROM `Members`
ORDER BY joindate DESC
LIMIT 1



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

/*ANSWER:  */
SELECT CONCAT( members.firstname, ' ', members.surname ) AS members_name, bookings.facid AS bookings_facility, facilities.name AS name
FROM country_club.Members members
JOIN country_club.Bookings bookings ON members.memid = bookings.memid
JOIN country_club.Facilities facilities ON bookings.facid = facilities.facid
WHERE name LIKE 'Tennis%'
AND members.firstname NOT LIKE '%GUEST%'
GROUP BY 1 , 3
ORDER BY 1 



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

/*ANSWER:  */
SELECT CONCAT(m.firstname, ' ', m.surname) AS name, 
f.name AS facility_name, 
CASE WHEN m.memid=0 
	 THEN f.guestcost * b.slots 
	 ELSE f.membercost * b.slots 
	 END AS cost
FROM country_club.Bookings b
JOIN country_club.Members m
ON m.memid = b.memid
JOIN country_club.Facilities f
ON b.facid = f.facid
WHERE b.starttime LIKE '2012-09-14%'
AND (
(
m.memid =0
AND b.slots * f.guestcost >30
)
OR (
m.memid !=0
AND b.slots * f.membercost >30
)
)
ORDER BY cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */

/*ANSWER:  */
SELECT name, 
facility, 
cost
FROM (
SELECT CONCAT( m.firstname, ' ', m.surname ) AS name, 
f.name AS facility,
CASE
WHEN m.memid =0
THEN b.slots * f.guestcost
ELSE b.slots * f.membercost
END AS cost
FROM `Members` m
JOIN `Bookings` b ON m.memid = b.memid
INNER JOIN `Facilities` f ON b.facid = f.facid
WHERE b.starttime >= '2012-09-14'
AND b.starttime < '2012-09-15'
) AS bookings
WHERE cost >30
ORDER BY cost DESC




/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/*ANSWER:  */
SELECT f.name AS facility_name, 
	   (f.membercost*COUNT(b.facid) + f.guestcost*COUNT(b.facid=0)) AS revenue
FROM country_club.Bookings as b
  JOIN country_club.Members as m
    ON m.memid = b.memid
  JOIN country_club.Facilities as f
    ON b.facid = f.facid
WHERE 'revenue'<1000
GROUP BY facility_name
