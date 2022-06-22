-- Lab 5
-- oslater
-- May 14, 2022

USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
select Source, Name from flights join airports on Code = Source
group by Source
having count(*) = 17
order by Source;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
select count(distinct a.Source) from flights a join flights b
where b.destination = "ANP"
and a.destination = b.source
and a.source != "ANP";


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
select count(distinct a.source) from flights a join flights b on a.source != "ATE"
where (b.destination = "ATE" and a.destination = b.source)
or a.Destination = "ATE";


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
select airlines.Name, count(distinct Code) from airlines join flights on Id = Airline join airports on Source = Code
group by airlines.Name
order by count(distinct Code) desc, airlines.Name;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the flavor, the average price (rounded to the nearest penny) of an item of this flavor, and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
select Flavor, round(avg(Price), 2) as avgPrice, count(Food) from goods
group by Flavor
having count(Food) > 3
order by avgPrice;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
select sum(price) from receipts join items on Receipt = RNumber join goods on Item = GId
where SaleDate BETWEEN '2007-10-01' and '2007-10-31'
and Food = "Eclair";


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, sale date, total number of items purchased, and amount paid, rounded to the nearest penny. Sort by the amount paid, greatest to least.
select Receipt, SaleDate, count(Ordinal), round(sum(price), 2) as paid
from customers join receipts on Customer = CId join items on Receipt = RNumber join goods on Item = GId
where LastName = "STENZ" and FirstName = "NATACHA"
group by Receipt
order by paid desc;


USE `BAKERY`;
-- BAKERY-4
-- For the week starting October 8, report the day of the week (Monday through Sunday), the date, total number of purchases (receipts), the total number of pastries purchased, and the overall daily revenue rounded to the nearest penny. Report results in chronological order.
select DAYNAME(SaleDate), SaleDate, count(distinct receipt), count(ordinal), round(sum(Price), 2)
from receipts join items on receipt = RNumber join goods on Item = GId
where SaleDate BETWEEN '2007-10-08' and '2007-10-14'
group by SaleDate
order by SaleDate;


USE `BAKERY`;
-- BAKERY-5
-- Report all dates on which more than ten tarts were purchased, sorted in chronological order.
select SaleDate from receipts join items on RNumber = receipt join goods on Item = GId
where Food = "Tart"
group by SaleDate
having count(Food) > 10
order by SaleDate;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the campus name and total of fees for this six year period. Sort in ascending order by fee.
select Campus, sum(fee) from fees join campuses on CampusId = Id
where fees.Year > 1999 and fees.Year < 2006
group by Campus
having avg(fee) > 2500
order by sum(fee);


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the campus name along with the average, minimum and maximum enrollment (over all years). Sort your output by average enrollment.
select Campus, avg(Enrolled), min(Enrolled), max(Enrolled) from enrollments join campuses on CampusId = Id
group by Campus
having count(enrollments.Year) > 60
order by avg(Enrolled);


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the campus name and total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

select Campus, sum(degrees) from degrees join campuses on CampusId = Id
where (County = "Los Angeles" or County = "Orange")
and degrees.year > 1997 and degrees.year < 2003
group by Campus
order by sum(degrees) desc;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the campus name and the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
select Campus, count(Gr) from enrollments join campuses on enrollments.CampusId = Id join discEnr on discEnr.CampusId = Id
where enrollments.Year = 2004 and Enrolled > 20000 and Gr > 0
group by Campus
order by Campus;


USE `INN`;
-- INN-1
-- For each room, report the full room name, total revenue (number of nights times per-night rate), and the average revenue per stay. In this summary, include only those stays that began in the months of September, October and November of calendar year 2010. Sort output in descending order by total revenue. Output full room names.
select RoomName, 
sum(rate * (DATEDIFF(Checkout, CheckIn))) AS AmountPaid, 
round(avg(rate * (DATEDIFF(Checkout, CheckIn))),2)
from reservations join rooms on RoomCode = Room
where Month(CheckIn) > 8 and Month(CheckIn) < 12
group by RoomName
order by AmountPaid desc;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
select count(*), sum(rate * (DATEDIFF(Checkout, CheckIn)))
from reservations join rooms on Room = RoomCode 
where DAYNAME(CheckIn) = "Friday";


USE `INN`;
-- INN-3
-- List each day of the week. For each day, compute the total number of reservations that began on that day, and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
select DAYNAME(CheckIn), count(code), sum(rate * (DATEDIFF(Checkout, CheckIn)))
from reservations
group by DAYOFWEEK(CheckIn), DAYNAME(CheckIn)
order by DAYOFWEEK(CheckIn);


USE `INN`;
-- INN-4
-- For each room list full room name and report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
select RoomName, max(rate - basePrice) as markup, min(rate - basePrice) from reservations join rooms on RoomCode = Room 
group by RoomName
order by markup desc, RoomName;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room, and the number of occupied nights. Sort in descending order by occupied nights. (Note: this should be number of nights during 2010. Some reservations extend beyond December 31, 2010. The ”extra” nights in 2011 must be deducted).
show tables

select * from reservations
select * from rooms

select a.Room, RoomName, 
(sum(DATEDIFF(a.CheckOut, a.CheckIn)) - sum(distinct DATEDIFF(b.CheckOut, '2011-01-01'))) as stayed
from reservations a 
join rooms on RoomCode = a.Room join reservations b on a.Room = b.Room
where Year(a.CheckIn) <= 2010
and Year(b.CheckIn) <= 2010 and Year(b.CheckOut) > 2010
group by a.Room, RoomName
order by stayed desc


select * from reservations
where Room = "SAY";


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer, report first name and how many times she sang lead vocals on a song. Sort output in descending order by the number of leads. In case of tie, sort by performer first name (A-Z.)
select Firstname, count(Song) from Band join Vocals on Bandmate = Id and VocalType = "lead"
group by Firstname
order by count(song) desc, Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Include performer's first name and the count of different instruments. Sort the output by the first name of the performers.
select Firstname, count(distinct Instrument) 
from Albums join Tracklists on Album = AId 
join Songs on Songs.SongId = Tracklists.Song
join Instruments on Instruments.Song = Tracklists.Song 
join Band on Bandmate = Id
where Albums.Title = "Le Pop"
group by Firstname
order by Firstname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List each stage position along with the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

select StagePosition, count(Song) from Performance join Band on Id = Bandmate
where Firstname = "Turid"
group by StagePosition
order by count(Song);


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. List performer first name and a number for each performer. Sort output alphabetically by the name of the performer.

select distinct c.FirstName, count(distinct b.Song) from Performance
join Band on Bandmate = Id
join Songs on Song = SongId
join Instruments on Performance.Song = Instruments.Song and Instruments.Song = SongId
join Instruments b on b.Song = SongId
join Band c on c.Id = b.Bandmate
where 
Band.FirstName = "Anne-Marit" and StagePosition = "left" and c.FirstName != "Anne-Marit" and b.Instrument = "bass balalaika"
group by c.FirstName
order by c.FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
select Instrument from Instruments
group by Instrument
having count(distinct Bandmate) >= 3
order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, list first name and report the number of songs on which they played more than one instrument. Sort output in alphabetical order by first name of the performer
select FirstName, count(distinct a.Song) from Band join Instruments a on a.Bandmate = Id
join Instruments b on b.Bandmate = Id and a.Song = b.Song
where a.Instrument != b.Instrument
group by FirstName
order by Firstname;


USE `MARATHON`;
-- MARATHON-1
-- List each age group and gender. For each combination, report total number of runners, the overall place of the best runner and the overall place of the slowest runner. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
select AgeGroup, Sex, count(Place), min(Place), max(Place) from marathon 
group by AgeGroup, Sex
order by AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
select count(*) from marathon a join marathon b on a.AgeGroup = b.AgeGroup and a.Sex = b.Sex
where a.GroupPlace = 1 and b.GroupPlace = 2 and a.State = b.State;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
select Minute(Pace), Count(*) from marathon
group by Minute(Pace);


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Report state code and the number of top 10 runners. Sort in descending order by the number of top 10 runners, then by state A-Z.
select State, count(Place) from marathon
where GroupPlace < 11
group by State
having count(Place) > 0
order by count(Place) desc;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the town name and average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
select Town, round(avg(time_to_sec(RunTime)), 1) as time from marathon
where State = "CT"
group by Town
having count(Place) >= 3
order by time;


USE `STUDENTS`;
-- STUDENTS-1
-- Report the last and first names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
select Last, First from teachers join list on teachers.classroom = list.classroom
group by Last, First
having count(LastName) = 7 or count(LastName) = 8
order by Last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the grade, the number of classrooms in which it is taught, and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

select grade, count(distinct classroom), count(*) from list
group by grade
order by count(distinct classroom) desc, grade;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report classroom number along with the total number of students in the classroom. Sort output in the descending order by the number of students.
select classroom, count(*) from list
where grade = 0
group by classroom
order by count(*) desc;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the classroom number and the last name of the student who appears last (alphabetically) on the class roster. Sort output by classroom.
select classroom, max(LastName) from list
where grade = 4
group by classroom
order by classroom;


