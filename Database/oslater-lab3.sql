-- Lab 3
-- oslater
-- Apr 24, 2022

USE `oslater`;
-- BAKERY-1
-- Using a single SQL statement, reduce the prices of Lemon Cake and Napoleon Cake by $2.
UPDATE goods
SET Price = Price - 2.00
WHERE (Food = "Cake" AND Flavor = "Lemon") OR (Food = "Cake" AND Flavor = "Napoleon");


USE `oslater`;
-- BAKERY-2
-- Using a single SQL statement, increase by 15% the price of all Apricot or Chocolate flavored items with a current price below $5.95.
UPDATE goods
SET Price = Price + (Price * 0.15)
WHERE (Flavor = "Chocolate" OR Flavor = "Apricot") AND (Price < 5.95);


USE `oslater`;
-- BAKERY-3
-- Add the capability for the database to record payment information for each receipt in a new table named payments (see assignment PDF for task details)
DROP TABLE IF EXISTS payments;

CREATE TABLE payments(
    Receipt INTEGER,
    Amount DECIMAL(5,2),
    PaymentSettled DATETIME,
    PaymentType VARCHAR(100),
    primary key(Receipt, Amount, PaymentSettled, PaymentType),
    foreign key (Receipt) references receipts(RNumber)
);


USE `oslater`;
-- BAKERY-4
-- Create a database trigger to prevent the sale of Meringues (any flavor) and all Almond-flavored items on Saturdays and Sundays.
CREATE TRIGGER food_check BEFORE INSERT ON items
FOR EACH ROW
  BEGIN
    DECLARE sale_date DATE;
    DECLARE flavor_check VARCHAR(100);
    DECLARE type_check VARCHAR(100);
    SELECT SaleDate INTO sale_date FROM receipts WHERE RNumber = NEW.Receipt;
    SELECT Flavor INTO flavor_check FROM goods WHERE GId = NEW.Item;
    SELECT Food INTO type_check FROM goods WHERE GId = NEW.Item;

IF ((DAYNAME(sale_date) = "Saturday") OR (DAYNAME(sale_date) = "Sunday")) 
   AND 
   ((flavor_check = "Almond") OR (type_check = "Meringue")) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'cant sell you that today';
    END IF;
  END;


USE `oslater`;
-- AIRLINES-1
-- Enforce the constraint that flights should never have the same airport as both source and destination (see assignment PDF)
create trigger flights_source_dest before insert on flights
for each row
begin
 if (NEW.SourceAirport = NEW.DestAirport) then
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Source and destination cannot be the same';
 end if;
end;


USE `oslater`;
-- AIRLINES-2
-- Add a "Partner" column to the airlines table to indicate optional corporate partnerships between airline companies (see assignment PDF)
ALTER TABLE airlines ADD COLUMN Partner VARCHAR(100);
ALTER TABLE airlines ADD UNIQUE(Partner);

ALTER TABLE airlines 
ADD CONSTRAINT partner_constraint 
FOREIGN KEY (Partner) 
REFERENCES airlines(Abbreviation);

UPDATE airlines
SET Partner = "Southwest"
WHERE Airline = "JetBlue Airways";

UPDATE airlines
SET Partner = "JetBlue"
WHERE Airline = "Southwest Airlines";

create trigger airline_partner before insert on airlines
for each row
begin
 if (NEW.Partner = NEW.Abbreviation) then
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Cannot self partner';
 end if;
end;

create trigger airline_partner_update before update on airlines
for each row
begin
 if (NEW.Partner = OLD.Abbreviation) then
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Cannot self partner';
 end if;
end;


USE `oslater`;
-- KATZENJAMMER-1
-- Change the name of two instruments: 'bass balalaika' should become 'awesome bass balalaika', and 'guitar' should become 'acoustic guitar'. This will require several steps. You may need to change the length of the instrument name field to avoid data truncation. Make this change using a schema modification command, rather than a full DROP/CREATE of the table.
UPDATE Instruments
SET Instrument = "awesome bass balalaika"
WHERE Instrument = "bass balalaika";

UPDATE Instruments
SET Instrument = "acoustic guitar"
WHERE Instrument = "guitar";


USE `oslater`;
-- KATZENJAMMER-2
-- Keep in the Vocals table only those rows where Solveig (id 1 -- you may use this numeric value directly) sang, but did not sing lead.
DELETE FROM Vocals
WHERE Bandmate != 1 OR `Type` = "lead";


