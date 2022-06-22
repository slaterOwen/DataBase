-- Lab 6
-- oslater
-- May 24, 2022

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
select distinct FirstName, LastName from receipts join customers on Customer = CId
where Customer not in (
    select Customer from receipts
    where SaleDate >= "2007-10-5" and SaleDate <= "2007-10-11")
order by LastName;


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
select FirstName, LastName, round(spent, 2) from 
(select FirstName, LastName, SUM(Price) as spent from receipts 
join items on Receipt = RNumber
join goods on GId = Item
join customers on Customer = CId
where month(SaleDate) = 10 and year(SaleDate) = 2007
group by Customer) as spentTable
where spent = (select max(spent) from (
select FirstName, LastName, SUM(Price) as spent from receipts 
join items on Receipt = RNumber
join goods on GId = Item
join customers on Customer = CId
where month(SaleDate) = 10 and year(SaleDate) = 2007
group by Customer) as spentTable2)
order by LastName;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

select distinct FirstName, LastName from receipts join customers on customer = CId
where Customer not in (
    select Customer from receipts 
    join items on Receipt = RNumber
    join goods on GId = item
    join customers on Customer = CId
    where month(SaleDate) = 10 and year(SaleDate) = 2007
    and Food = "Twist")
order by LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find the baked good(s) (flavor and food type) responsible for the most total revenue.
select Flavor, Food from 
(select Flavor, Food, SUM(Price) as total from receipts 
join items on Receipt = RNumber
join goods on GId = item
group by Flavor, Food) as foodTotal1
where total = (select max(total) from (
select Flavor, Food, SUM(Price) as total from receipts 
join items on Receipt = RNumber
join goods on GId = item
group by Flavor, Food) as foodTotal2);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (flavor and food) and total quantity sold.
select Flavor, Food, numberSold from (select Flavor, Food, count(*) as numberSold from items join goods on GId = item
group by Flavor, Food) as numS1
where numberSold = (select MAX(numberSold) from (
select Flavor, Food, count(*) as numberSold from items join goods on GId = item
group by Flavor, Food) as numS2);


USE `BAKERY`;
-- BAKERY-6
-- Find the date(s) of highest revenue during the month of October, 2007. In case of tie, sort chronologically.
select SaleDate from (select SaleDate, SUM(Price) as total from receipts 
join items on receipt = RNumber
join goods on GId = Item
where month(SaleDate) = 10 and year(SaleDate) = 2007
group by SaleDate) as tTable
where total = (select MAX(total) from (
select SaleDate, SUM(Price) as total from receipts 
join items on receipt = RNumber
join goods on GId = Item
where month(SaleDate) = 10 and year(SaleDate) = 2007
group by SaleDate) as tTable2);


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item(s) (by number of purchases) on the day(s) of highest revenue in October of 2007.  Report flavor, food, and quantity sold. Sort by flavor and food.
select Flavor, Food, totBought from 
    (select Flavor, Food, count(*) as totBought from receipts join items on RNumber = receipt join goods on GId = item
    where SaleDate = (select SaleDate from (select SaleDate, SUM(Price) as total from receipts 
        join items on receipt = RNumber
        join goods on GId = Item
        where month(SaleDate) = 10 and year(SaleDate) = 2007
        group by SaleDate) as tTable
        where total = (select MAX(total) from (
        select SaleDate, SUM(Price) as total from receipts 
        join items on receipt = RNumber
        join goods on GId = Item
        where month(SaleDate) = 10 and year(SaleDate) = 2007
        group by SaleDate) as tTable2))
    group by Item) as tb3

where totBought = (
select MAX(totBought) from (
    select Item, count(*) as totBought from receipts join items on RNumber = receipt
    where SaleDate = (select SaleDate from (select SaleDate, SUM(Price) as total from receipts 
        join items on receipt = RNumber
        join goods on GId = Item
        where month(SaleDate) = 10 and year(SaleDate) = 2007
        group by SaleDate) as tTable
        where total = (select MAX(total) from (
        select SaleDate, SUM(Price) as total from receipts 
        join items on receipt = RNumber
        join goods on GId = Item
        where month(SaleDate) = 10 and year(SaleDate) = 2007
        group by SaleDate) as tTable2))
    group by Item) as tB);


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the quantity purchased. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
WITH countForCakes as (
select Customer, FirstName, LastName, Flavor, Food, count(*) as numBought from 
goods join items on GId = Item 
join receipts on receipt = RNumber 
join customers on customer = CId
where Food = "Cake" and month(SaleDate) = 10 and year(SaleDate) = 2007
group by Customer, Flavor, Food)

select Flavor, Food, FirstName, LastName, numBought from countForCakes cfc1
where numBought = 
    (select MAX(numBought) from countForCakes cfc2
     where cfc1.Flavor = cfc2.Flavor)
order by numBought desc, LastName, Flavor;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (last, first) of the customers and the *earliest* day in October on which they made a purchase, sorted in chronological order, then by last name.

WITH 
    firstDay as 
    (select customer as c1, LastName, FirstName, Min(SaleDate) as earliestDay from receipts 
    join items on RNumber = receipt
    join customers on customer = CId
    where month(SaleDate) = 10
    group by customer),
    
    lastDay as
    (select customer as c2, LastName, FirstName, Max(SaleDate) as latestDay from receipts 
    join items on RNumber = receipt
    join customers on customer = CId
    where month(SaleDate) = 10
    group by customer)
    
select lastDay.LastName, lastDay.FirstName, earliestDay from firstDay 
join receipts on c1 = Customer
join lastDay on c2 = Customer and SaleDate = latestDay
group by customer, LastName, FirstName
having count(RNumber) > 1
order by earliestDay, lastDay.LastName;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

WITH 
    choc as 
    (select sum(Price) as tot from goods 
    join items on GId = item
    join receipts on receipt = RNumber
    where Flavor = "Chocolate"
    and month(SaleDate) = 10 and year(SaleDate) = 2007),
    
    cro as
    (select sum(Price) as tot from goods 
    join items on GId = item
    join receipts on receipt = RNumber
    where Food = "Croissant"
    and month(SaleDate) = 10 and year(SaleDate) = 2007)
select CASE WHEN choc.tot > cro.tot
    THEN 'Chocolate'
    ELSE 'Croissant'
    END
from choc join cro;


USE `INN`;
-- INN-1
-- Find the most popular room(s) (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room, report all such rooms). Report the full name of the room, the room code and the number of reservations.

WITH roomC as
    (select RoomName, Room, count(*) as rC from reservations join rooms on Room = RoomCode
    group by Room)
select RoomName, Room, rC from roomC
where rC = (select MAX(rC) from roomC);


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
WITH totRoom as
    (select RoomName, Room, sum(datediff(CheckOut, CheckIn)) as totDays from reservations join rooms on RoomCode = Room 
    group by Room)
select RoomName, Room, totDays from totRoom
where totDays = (select MAX(totDays) from totRoom);


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid (rounded to the nearest penny.) Sort the output in descending order by total amount paid.
WITH perRoom as
    (select CODE, CheckIn, Checkout, LastName, Rate, Room, RoomName, Rate * DateDiff(Checkout, CheckIn) as perRes from reservations
    join rooms on Room = RoomCode
    group by CODE)
select RoomName, CheckIn, Checkout, LastName, Rate, perRes from perRoom p1
where perRes = (
    select MAX(perRes) from perRoom p2
    where p1.Room = p2.Room
)
order by perRes DESC;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
select RoomName, Room, CASE
                         WHEN (RoomName not in (
                                select distinct RoomName
                                from rooms join reservations on Room = RoomCode
                                where CheckIn <= '2010-07-04' and Checkout > '2010-07-04'))
                           THEN "Empty"
                           ELSE "Occupied"
                           END as 4thStatus
from rooms join reservations on Room = RoomCode
group by RoomName, Room
order by Room;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month name, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
WITH 
    costs as(
            select *, (DateDiff(CheckOut, CheckIn) *  Rate) as cost from reservations),
    maxCosts as(
            select Month(CheckIn) as m, SUM(cost) as totalRev, count(*) num from costs
            group by Month(CheckIn))
    select MonthName(str_to_date(m, '%m')), num, totalRev
    from maxCosts
    where totalRev = (select MAX(totalRev) from maxCosts)
order by MonthName(str_to_date(m, '%m'));


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) with the largest number of students. Report the name of the teacher(s) (last, first) and the number of students in their class.

WITH stuCount as(
        select Last, First, count(*) as sCount from teachers join list on teachers.classroom = list.classroom
        group by Last, First)
select Last, First, sCount from stuCount
where sCount = (select MAX(sCount) from stuCount);


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students. In case of tie, sort by grade number.
WITH gCount as(
select grade, count(*) as sCount from list
where LastName like 'A%' or LastName like 'B%' or LastName like 'C%'
group by grade)
select grade, sCount from gCount
where sCount = (select MAX(sCount) from gCount);


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers and the number of student in each classroom. Sort in ascending order by classroom.
WITH classCount as(
select classroom, count(*) as sCount from list
group by classroom)
select classroom, sCount from classCount
where sCount < (select AVG(sCount) from classCount)
order by classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
WITH cCount as(
select classroom, count(*) as sCount from list
group by classroom)
select distinct c1.classroom, c2.classroom, c1.sCount from cCount c1 join cCount c2 on c1.sCount = c2.sCount
and c1.classroom < c2.classroom
order by c1.sCount;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the grade and the last name of the teacher who teaches the classroom with the largest number of students in the grade. Output results in ascending order by grade.
WITH gr as(
    select grade, count(distinct teachers.classroom) as numC from teachers
    join list on teachers.classroom = list.classroom
    group by grade
    having numC > 1),

    stuCount as(
    select grade, teachers.Last, teachers.First, Count(*) as sCount from teachers
    join list on teachers.classroom = list.classroom
    group by teachers.Last, teachers.First, grade)

select gr.grade,Last from stuCount s1 join gr on gr.grade = s1.grade
where 
sCount = (
    select MAX(sCount) from stuCount s2
    where s1.grade = s2.grade
)
order by s1.grade;


USE `CSU`;
-- CSU-1
-- Find the campus(es) with the largest enrollment in 2000. Output the name of the campus and the enrollment. Sort by campus name.

WITH y as(
select Enrolled, Campus from enrollments join campuses on CampusId = Id
where enrollments.year = 2000)
select Campus, Enrolled from y
where Enrolled = (select MAX(Enrolled) from y)
order by Campus;


USE `CSU`;
-- CSU-2
-- Find the university (or universities) that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university, sorted alphabetically.

WITH deg as(
select CampusId, Campus, SUM(degrees) as dSum from degrees join campuses on CampusId = Id
group by CampusId)
select Campus from deg 
where dSum = (select MAX(dSum) from deg);


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment. In case of tie, sort by campus name.
WITH r as(
select Campus, round(enrollments.FTE / faculty.FTE, 1) as stfRatio from campuses 
join faculty on faculty.CampusId = Id
join enrollments on enrollments.CampusId = Id
and enrollments.Year = faculty.Year
where enrollments.Year = 2003)
select Campus, stfRatio from r
where stfRatio = (select MIN(stfRatio) from r);


USE `CSU`;
-- CSU-4
-- Among undergraduates studying 'Computer and Info. Sciences' in the year 2004, find the university with the highest percentage of these students (base percentages on the total from the enrollments table). Output the name of the campus and the percent of these undergraduate students on campus. In case of tie, sort by campus name.
WITH 
    per as(
    select Campus, (Ug/Enrolled * 100) as percent from disciplines 
    join discEnr on Discipline = disciplines.Id
    join enrollments on enrollments.CampusId = discEnr.CampusId and enrollments.year = discEnr.year
    join campuses on campuses.Id = enrollments.CampusId
    where Name = "Computer and Info. Sciences" and discEnr.year = 2004)
select Campus, round(percent, 1) from per
where percent = (select MAX(percent) from per);


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the year, the name of the campuses, and the ratio. List in chronological order.
WITH 
 deg as(
        select enrollments.year, Campus, degrees/Enrolled as rat from degrees 
        join enrollments on enrollments.CampusId = degrees.CampusId and enrollments.year = degrees.year
        join campuses on Id = enrollments.CampusId
        where enrollments.year >= 1997 and enrollments.year <= 2003)
select * from deg d1
where rat = (select MAX(rat) from deg d2 where d1.Year = d2.Year)
order by year;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the highest student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios and round to two decimal places.
WITH 
    cRat as(
select Campus, enrollments.Year, MAX(enrollments.FTE / faculty.FTE) as rat  from enrollments 
join faculty on enrollments.CampusId = faculty.CampusId and enrollments.Year = faculty.Year
join campuses on Id = enrollments.CampusId
group by enrollments.Year, Campus)
select Campus, Year, ROUND(rat, 2) from cRat c1
where rat = (select MAX(rat) from cRat c2 where c1.Campus = c2.Campus)
order by Campus;


USE `CSU`;
-- CSU-7
-- For each year for which the data is available, report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

WITH 
    cRat as 
    (select Campus, enrollments.Year, MAX(enrollments.FTE / faculty.FTE) as rat 
    from campuses join faculty on Id = faculty.CampusId
    join enrollments on enrollments.CampusId = Id and enrollments.Year = faculty.Year
    group by enrollments.Year,Campus)
select Year + 1 as Year, Count(*) as count from cRat c1
where rat < (select MAX(rat) from cRat c2 where c1.Campus = c2.Campus
                                          and c2.Year = c1.Year + 1)
group by Year
order by Year;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

WITH
 stateCount as (
        select State, count(*) as sCount from marathon
        group by State)
select State from stateCount 
where sCount = (select MAX(sCount) from stateCount)
order by State;


USE `MARATHON`;
-- MARATHON-2
-- Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Include only those towns that fielded at least 1 male runner and at least 1 female runner. Report the names of towns, sorted alphabetically.

WITH
 nM as(
        select Town, count(*) as numMales from marathon
        where State = "RI" and Sex = "M"
        group by Town),
 nF as(
        select Town, count(*) as numFemales from marathon
        where State = "RI" and Sex = "F"
        group by Town)
select nM.Town from nM join nF on nM.Town = nF.Town
where numFemales > numMales
order by nM.Town;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
WITH 
    sC as(
        select State, Sex, agegroup, count(*) as sCount from marathon 
        group by State, Sex, agegroup)
select State, agegroup, Sex, sCount 
from sC s1
where s1.sCount = (select MAX(sCount) from sC s2 where s1.State = s2.State)
and sCount > 1
order by State, agegroup, Sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
select Place, FirstName, LastName from marathon m1
where Sex = 'F'
and (select Count(*) from marathon m2
    where sex = 'F' 
    and m2.Place < m1.Place) = 29
group by Place;


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

WITH
    mC as(
        select Town, count(*) as mCount from marathon
        where State = "CT"
        and Sex = "M"
        group by Town),
    fC as(
        select Town, count(*) as fCount from marathon
        where State = "CT"
        and Sex = "F"
        group by Town)
    (select mC.Town, mCount as m, COALESCE(fCount, 0) as f from mC LEFT OUTER JOIN fC on mC.Town = fC.Town)
     UNION ALL
    (SELECT fC.Town, COALESCE(mCount, 0), fCount FROM mC RIGHT OUTER JOIN fC ON (mC.Town = fC.Town)
    WHERE mC.Town IS NULL)
    order by (m + f) desc, Town;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

select Firstname from Band 
where Firstname not in (
select distinct Firstname from Instruments join Band on Bandmate = Id
where Instrument = "accordion" );


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

select Title from Songs
where SongId not in (select distinct Song from Vocals);


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
WITH
    iCount as(
        select Song, Title, count(*) as instN from Instruments join Songs on Song = SongId
        group by Song)
    select Title from iCount 
    where instN = (select MAX(instN) from iCount);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument, and the number of songs on which the performer played that instrument. Sort in alphabetical order by the first name, then instrument.

WITH
    iCount as(
    select Bandmate, Instrument, count(*) as iC from Instruments
    group by Bandmate, Instrument)
    select FirstName, Instrument, iC from iCount i1 join Band on Bandmate = Id
    where iC = (select MAX(iC) from iCount i2 where i2.Bandmate = i1.Bandmate)
    order by FirstName, Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instrument names in alphabetical order.
select Instrument from Instruments join Band on Bandmate = Id
where Instrument not in (select distinct Instrument from Band join Instruments on Bandmate = Id
where FirstName != "Anne-Marit")
and FirstName = "Anne-Marit"
order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report, in alphabetical order, the first name(s) of the performer(s) who played the largest number of different instruments.

WITH iC as(
        select Bandmate, FirstName, count(distinct Instrument) as iCount from Instruments join Band on Id = BandMate
        group by Bandmate)
    select FirstName from iC 
    where iCount = (select MAX(iCount) from iC)
    order by FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments, sorted alphabetically (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
WITH iC as(
        select Instrument, count(distinct Song) as iCount from Instruments
        group by Instrument) 
    select Instrument from iC
    where iCount = (select MAX(iCount) from iC)
    order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s), sorted in alphabetical order.

WITH iC as(
        select Bandmate, count(distinct Song) as iCount from Performance
        where StagePosition = "center"
        group by Bandmate)
    select FirstName from iC join Band on Bandmate = Id
    where iCount = (select MAX(iCount) from iC)
    order by FirstName;


