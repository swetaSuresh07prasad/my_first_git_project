create database EventDB;
use EventDB;
create table Venu(
venu_id int primary key,
venu_name varchar (100),
venu_location varchar(100),
venu_capacity int
);
desc Venu;
-- drop table Venu;
insert into Venu(venu_id, venu_name, venu_location, venu_capacity)
values(1, 'NCPA', 'Churchgate, Nariman point, Mumbai', 1109),
(2, 'Sunset Arena', '456 Sunset Blvd, Oceanview', 630),
(3, 'Royal Ballroom', '202 Royal St., Uptown', 350),
(4, 'Starlight Auditorrium', '403 Grand Road, Silicon Valley', 975),
(5, 'Nehru Center', 'Worli, Mumbai', 800),
(6, 'Union Chapel', '19b Compton Terrace, London N1 2UN', 1260);
select * from Venu;

create table Events(
event_id int primary key,
event_name varchar (100),
event_date datetime,
event_time time,
venu_id int,
event_status enum('Active', 'Cancelled', 'Completed') default 'Active',
event_description text,
foreign key (venu_id) references Venu(venu_id)
);
desc Events;
insert into Events
(event_id, event_name, event_date, event_time, venu_id, event_status, event_description)
values
(101, 'Summer Music Festival', '2025-07-20', '14:00:00', 5, 'Active', 'An outdoor music festival with performances from top artists.'),
(102, 'Sitar for Mental Health', '2025-01-25', '19:00:00', 1, 'Completed', 'Sitar Music by Rishab Sharma for Mental Health'),
(103, 'Foodie Fair', '2025-07-15', '11:00:00', 2, 'Active', 'A food festival featuring local and international cuisines.'),
(104, 'Kirtan', '2025-04-10', '20:00:00', 3, 'Active', 'Live Bhajan and Kirtan of Radha Krshn'),
(105, 'Book Fest', '2025-03-10', '15:00:00', 3, 'Cancelled', 'Visit of Shantanu Naidu'), 
(106, 'Inspiration Through Nature', '2025-02-24', '10:30:00', 6, 'Completed', 'Creative workshop where the natural environment is the muse.');
select * from Events;

create table Attendees(
attendee_id int primary key,
first_name varchar (100),
last_name varchar(100),
email varchar(100),
phone_number bigint 
);
INSERT INTO Attendees (attendee_id, first_name, last_name, email, phone_number) VALUES
(1, 'Oliver', 'Tylor', 'tolive@example.com', 9876543210),
(2, 'Aarav', 'Goinka', 'goinka.arav@gmail.com', 6904590531),
(3, 'Sarah', 'Dsouza', 'sarahD@gamil..com', 8945200419),
(4, 'Lily', 'Martinez', 'lily.martinez@example.com', '5438761092'),
(5, 'Megan', 'Clark', 'megan.clark@example.com', '7650983214'),
(6, 'Daniel', 'Walker', 'daniel.walker@example.com', '8761094325'),
(7, 'Sophia', 'Hernandez', 'sophia.hernandez@example.com', '9872105436'),
(8, 'Lucas', 'Allen', 'lucas.allen@example.com', '0983216547'),
(9, 'Grace', 'Young', 'grace.young@example.com', '1094327658'),
(10, 'Evan', 'King', 'evan.king@example.com', '2105438769');

select * from Attendees;

create table Registration (
registration_id int primary key,
event_id int,
attendee_id int,
registration_date datetime default current_timestamp,
registration_status enum('Registered', 'Cancelled', 'Completed') default 'Registered',
foreign key (attendee_id) references Attendees(attendee_id),
foreign key (event_id) references Events(event_id)
);

insert into Registration (registration_id, event_id, attendee_id, registration_date, registration_status)
values(401, 101, 1, '2025-03-01 10:30:00', 'Registered'),
(402, 102, 2, '2025-03-02 14:45:00', 'Registered'),
(403, 103, 3, '2025-03-03 09:00:00', 'Completed'),
(404, 106, 4, '2025-03-04 16:20:00', 'Cancelled'),
(405, 104, 5, '2025-03-05 12:10:00', 'Registered'),
(406, 102, 6, '2025-03-06 11:15:00', 'Completed'),
(407, 103, 7, '2025-03-07 13:00:00', 'Registered'),
(408, 105, 8, '2025-03-08 17:30:00', 'Registered'),
(409, 106, 9, '2025-02-24 12:00:00', 'Completed'),
(410, 105, 10, '2025-01-18 20:00:00', 'Cancelled');
select * from Registration;

delimiter $$

create procedure DeleteEvents(
in p_event_id int)
begin 
	if (select count(*) from Registration where event_id=event_id) > 0 then 
		signal sqlstate '45000' set message_text= 'Cannot delete event. There are registered attendees ';
	else 
		delete from Registration where event_id=event_id;
        delete from Events where event_id=event_id;
	End if;

end $$ 
delimiter ;


delimiter $$
create procedure UpdateEventsStatus(
in p_event_id int,
in new_status varchar(50))
begin 
	update Events set event_status= new_event_status where event_id=event_id;
    update Registration set registration_status ='Cancelled' where event_id=event_id;

 end $$
delimiter ;


delimiter $$
create procedure SentEventReminder(in event_id int, in days_before int)
begin 
	declare event_date date;
    
    select event_date into event_date from Events where event_id=event_id;
    
	select a.email, e.event_name, e.event_date from Attendees a 
    join Registration r on a.attendees_id= r.attendees_id 
	join Events e on e.event_id = r.event_id 
    where r.event_id = event_id and datediff(event_date, curdate()) = days_before;
    
end $$
delimiter ;


select * from Venu;
select * from Events;
select * from Attendees;
select * from Registration;
