-- Lab 4
-- oslater
-- May 3, 2022

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
select FirstName,LastName from list where classroom = 111 order by LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
select distinct classroom,grade from list order by classroom desc;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
SELECT distinct First,Last,classroom FROM teachers NATURAL JOIN list where grade = 5 order by classroom;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
SELECT distinct FirstName,LastName FROM teachers NATURAL JOIN list where (Last = "MOYER" AND First = "OTHA") order by LastName;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Output teacher last name, first name, and grade. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
SELECT distinct Last,First,grade FROM teachers NATURAL JOIN list where grade < 4 order by grade,Last;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
select Flavor,Food,Price from goods where (Price < 5.00 AND Flavor = "Chocolate") order by Price DESC;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
select Flavor,Food,Price from goods where 
((Food = "Cookie" AND Price > 1.10) OR (Flavor = "Lemon") OR (Flavor = "Apple" AND Food != "Pie"))
order by Flavor,Food;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
select distinct LastName,FirstName from customers,receipts where (SaleDate = "2007-10-03" AND Customer = CId) order by LastName;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
SELECT DISTINCT Flavor,Food
   FROM receipts, items, goods
   WHERE (receipts.RNumber = items.Receipt AND receipts.SaleDate = "2007-10-04" AND Food = "Cake" AND goods.GId = item)
   order by Flavor;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
select Flavor,Food,Price from receipts,customers,items,goods where 
(receipts.Customer = customers.CId AND 
receipts.RNumber = items.Receipt AND
receipts.SaleDate = "2007-10-25" AND
customers.FirstName = "ARIANE" AND
customers.LastName = "CRUZEN" AND
items.Item = goods.GId)
order by items.Ordinal;


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

SELECT DISTINCT Flavor,Food
FROM receipts,items,customers,goods
WHERE (SaleDate <= STR_TO_DATE('10/31/2007', '%m/%d/%Y') AND SaleDate >= STR_TO_DATE('10/01/2007', '%m/%d/%Y')
AND RNumber = Receipt
AND Customer = CId
AND Item = GId
AND LastName = "ARNN"
AND FirstName = "KIP"
AND Food = "Cookie")
order by Flavor;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
select Campus from campuses where County = "Los Angeles" order by Campus;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
select degrees.year,degrees from campuses,degrees where 
(Id = CampusId AND 
degrees.year >= 1994 AND 
degrees.year <= 2000 AND 
Campus = "California Maritime Academy")
order by degrees.year;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
select Campus,Name,Gr,Ug from discEnr,disciplines,campuses where 
(discEnr.Discipline = disciplines.Id AND
CampusId = campuses.Id AND
(Name = "Computer and Info. Sciences" OR
Name = "Engineering" OR
Name = "Mathematics") AND
discEnr.Year = 2004 AND
(Campus = "California State Polytechnic University-Pomona" OR
Campus = "California Polytechnic State University-San Luis Obispo"))
order by Campus,Name;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
select Campus, a1.Gr, b1.Gr from campuses
join disciplines a
join discEnr a1 on campuses.Id = a1.CampusId and a.Id = a1.Discipline and a.Name = "Agriculture"
join disciplines b
join discEnr b1 on campuses.Id = b1.CampusId and b.Id = b1.Discipline and b.Name = "Biological Sciences"
where 
a1.Year = 2004 AND
a1.Gr != 0 AND
b1.Gr != 0
order by a1.Gr DESC;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names, discipline names, and both enrollment counts. Sort output by campus name, then by discipline name in alphabetical order.
select campuses.Campus, disciplines.Name, discEnr.Ug, discEnr.Gr from campuses,discEnr,disciplines where 
(campuses.Id = discEnr.CampusId AND
discEnr.Year = 2004 AND
discEnr.Discipline = disciplines.Id AND 
discEnr.Gr > (3 * discEnr.Ug))
order by campuses.Campus, disciplines.Name;


USE `CSU`;
-- CSU-6
-- Report the amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
select fees.Year, fees.fee * enrollments.FTE, ROUND((fees.fee * enrollments.FTE) / faculty.FTE, 2) from fees
join enrollments on fees.CampusId = enrollments.CampusId and fees.Year = enrollments.Year
join faculty on fees.Year = faculty.Year and faculty.CampusId = fees.CampusId
join campuses on fees.CampusId = campuses.Id
where
(campuses.Campus = "Fresno State University" AND
fees.Year >= 2002 AND
fees.Year <= 2004)
order by fees.Year;


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
select distinct a.Campus, a1.FTE, f.FTE, ROUND(a1.FTE/f.FTE, 1) as ratio from campuses a
join enrollments a1 on a1.CampusId = a.Id and a1.Year = 2003
join campuses b
join enrollments b1 on b1.CampusId = b.Id and b.Campus = "San Jose State University" and b1.Year = 2003
join faculty f on f.Year = 2003 and f.CampusId = a.Id
where(a1.FTE > b1.FTE)
order by ratio;


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room code and full room name, in alphabetical order by the code.
select distinct Roomcode, RoomName from rooms where
(basePrice < 165 AND decor = "modern" AND Beds = 2)
order by rooms.RoomCode;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
SELECT DISTINCT LastName, CheckIn, Checkout, (Adults + Kids), Rate
FROM reservations,rooms
WHERE 
(rooms.RoomCode = reservations.Room AND
reservations.CheckIn >= STR_TO_DATE('2010-07-01', '%Y-%m-%d') AND reservations.Checkout <= STR_TO_DATE('2010-08-01', '%Y-%m-%d')
AND rooms.RoomName = "Convoke and sanguine")
order by CheckIn;


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
select distinct RoomName,CheckIn,Checkout from reservations,rooms where(
CheckIn <= '2010-02-06' AND CheckOut > '2010-02-06'
AND Room = RoomCode)
order by RoomName;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, room name (full), checkin and checkout dates, and the total stay cost. Sort output in chronological order by the day of arrival.

select 
reservations.CODE, rooms.RoomName, reservations.CheckIn, reservations.Checkout, 
(DATEDIFF(reservations.Checkout, reservations.CheckIn) * reservations.Rate) AS AmountPaid
from reservations, rooms where 
(reservations.LastName = "KNERIEN" AND
reservations.FirstName = "GRANT" AND
reservations.Room = rooms.RoomCode)
order by reservations.CheckIn;


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
select RoomName, Rate, DATEDIFF(Checkout, CheckIn) AS NightsStayed, (DATEDIFF(Checkout, CheckIn) * Rate) AS AmountPaid
from reservations, rooms where (
CheckIn = "2010-12-31" AND
Room = RoomCode)
order by NightsStayed DESC;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the room abbreviation, full name of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
select CODE, RoomCode, RoomName, CheckIn, Checkout from rooms, reservations where(
Room = RoomCode AND
bedType = "Double" AND
Adults = 4)
order by CheckIn, RoomCode;


USE `MARATHON`;
-- MARATHON-1
-- Report the overall place, running time, and pace of TEDDY BRASEL.
select Place, RunTime, Pace from marathon where(
FirstName = "TEDDY" AND
LastName = "BRASEL");


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), overall place, running time, as well as place within gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
select FirstName, LastName, Place, RunTime, GroupPlace from marathon where(
Sex = "F" AND
Town = "QUNICY" AND
STATE = "MA")
order by Place;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
select FirstName, LastName, Town, RunTime from marathon where(
Age = 34 AND
Sex = "F" AND
State = "CT")
order by RunTime;


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
Select distinct a.BibNumber from marathon a
join marathon b
where (a.BibNumber = b.BibNumber AND a.Place != b.Place)
order by a.BibNumber;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. List gender, age group, name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
select distinct a.Sex, a.AgeGroup, a.FirstName, a.LastName, a.Age, b.FirstName, b.LastName, b.Age
from marathon a join marathon b on b.GroupPlace = 2 and a.AgeGroup = b.AgeGroup and a.GroupPlace = 1 and a.Sex = b.Sex
order by a.Sex, a.AgeGroup;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
select distinct airlines.Name, airlines.Abbr from airports, flights, airlines where(
airlines.Id = flights.Airline AND
flights.Source = "AXX")
order by airlines.Name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

select flights.FlightNo, flights.Destination, airports.Name 
from airports, flights JOIN airlines ON airlines.Id = flights.Airline where(
airports.Code = flights.Destination AND
airlines.Name = "Northwest Airlines" AND
flights.Source = "AXX")
order by flights.FlightNo;


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
select a1.FlightNo, b1.FlightNo, b1.Destination, airports.Name from airlines a
join flights a1 on a.Id = a1.Airline and a.Name = "Northwest Airlines" and a1.Source = "AXX"
join airlines b
join flights b1 on b.Id = b1.Airline and b.Name = "Northwest Airlines" and b1.Source =  a1.Destination
join airports on airports.Code = b1.Destination and airports.Code != "AXX"
order by b1.Destination;


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
select distinct a.Source, b.Destination from flights a 
join airlines a1 on a.Airline = a1.Id and a1.Name = "Frontier Airlines"
join flights b
join airlines b1 on b.Airline = b1.Id and b1.Name = "JetBlue Airways" and b.Source = a.Source and b.Destination = a.Destination
and b.Source < a.Destination;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
select distinct e3.Code from flights a
join airports a1 on a1.Code = a.Source or a1.Code = a.Destination
join airlines a2 on a2.Id = a.Airline and a2.Name = "Delta Airlines"
join airlines b on b.Name = "Frontier Airlines"
join flights b1 on b.Id = b1.Airline
join airports b3 on b3.Code = b1.Source or b3.Code = b1.Destination
join airlines c on c.Name = "US Airways"
join flights c1 on c.Id = c1.Airline
join airports c3 on c3.Code = c1.Source or c3.Code = c1.Destination
join airlines d on d.Name = "United Airlines"
join flights d1 on d.Id = d1.Airline
join airports d3 on d3.Code = d1.Source or d3.Code = d1.Destination
join airlines e on e.Name = "Southwest Airlines"
join flights e1 on e.Id = e1.Airline
join airports e3 on e3.Code = e1.Source or e3.Code = e1.Destination
where(
e3.Code = d3.Code AND d3.Code = c3.Code and c3.Code = b3.Code and b3.Code = a1.Code)
order by e3.Code;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
select distinct a.Code from airports a
join flights a1 on a.Code = a1.Destination
join airlines a2 on a1.Airline = a2.Id and a2.Name = "Southwest Airlines"
join airports b
join flights b1 on b.Code = b1.Destination
join airlines b2 on b1.Airline = b2.Id and b2.Name = "Southwest Airlines"
join airports c
join flights c1 on c.Code = c1.Destination
join airlines c2 on c1.Airline = c2.Id and c2.Name = "Southwest Airlines"
where(
a1.FlightNo != b1.FlightNo AND a1.FlightNo != c1.FlightNo AND b1.FlightNo != c1.FlightNo
AND a.Code = b.Code and b.Code = c.Code)
order by a.Code;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
select Songs.Title from Tracklists join Albums on AId = Album join Songs on Song = SongId
where(
Albums.Title = "Le Pop")
order by Position;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
select FirstName, Instrument from Instruments join Songs on Song = SongId join Band on Id = Bandmate where(
Songs.Title = "Mother Superior")
order by FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
select distinct Instrument from Instruments 
join Performance on Instruments.Bandmate = Performance.Bandmate 
join Band on Band.Id = Performance.Bandmate
where(FirstName = "Anne-Marit")
order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
select Title from Instruments join Songs on Instruments.Song = SongId
where(Instrument = "ukalele")
order by Title;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
select distinct Instrument from Instruments 
join Vocals on Instruments.Song = Vocals.Song and Instruments.Bandmate = Vocals.Bandmate
join Band on Id = Instruments.Bandmate
where(
FirstName = "Turid" AND
VocalType = "lead")
order by Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song, then name of band member. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
select Title, FirstName, StagePosition from Performance 
join Vocals on Performance.Song = Vocals.Song and Performance.Bandmate = Vocals.Bandmate
join Songs on Performance.Song = Songs.SongId
join Band on Id = Performance.Bandmate
where(StagePosition != "center" AND VocalType = "lead")
order by Title, FirstName;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
select distinct Songs.Title from Songs
join Instruments a on a.Song = Songs.SongId
join Band on Band.Id = a.Bandmate and Band.Firstname = "Anne-Marit"
join Instruments b on b.Bandmate = Band.Id and b.Song = Songs.SongId
join Instruments c on c.Bandmate = Band.Id and c.Song = Songs.SongId
where(
a.Instrument != b.Instrument AND
b.Instrument != c.Instrument
);


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
select a1.Firstname, b1.Firstname, c1.Firstname, d1.Firstname from Songs
join Performance a on a.Song = Songs.SongId and Songs.Title = "A Bar In Amsterdam" and a.StagePosition = "right"
join Band a1 on a1.Id = a.Bandmate
join Performance b on b.Song = Songs.SongId and Songs.Title = "A Bar In Amsterdam" and b.StagePosition = "center"
join Band b1 on b1.Id = b.Bandmate
join Performance c on c.Song = Songs.SongId and Songs.Title = "A Bar In Amsterdam" and c.StagePosition = "back"
join Band c1 on c1.Id = c.Bandmate
join Performance d on d.Song = Songs.SongId and Songs.Title = "A Bar In Amsterdam" and d.StagePosition = "left"
join Band d1 on d1.Id = d.Bandmate;


