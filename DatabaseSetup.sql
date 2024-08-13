use master
go

create database ICH
go

use ICH
go

create table ClaimTypes (
	ID int primary key identity (1, 1),
	[Name] varchar(50) not null
)
go

create table Claims (
	ID int primary key identity (1, 1),
	[Name] varchar(50) not null,
	GrossClaim decimal(10, 2) not null,
	Deductable decimal(10, 2) not null,
	TypeID int,
	[Year] int

	constraint fk_claims_claimsTypes foreign key (TypeID)
	references ClaimTypes(ID)
)
go

set IDENTITY_INSERT ClaimTypes on
go

insert into ClaimTypes 
(ID, [Name])
values 
(1, 'Collision'),
(2, 'Grounding'),
(3, 'Bad Weather'),
(4, 'Fire')
go

set IDENTITY_INSERT ClaimTypes off
go

set IDENTITY_INSERT Claims on
go

insert into CLaims 
(ID, [Name],GrossClaim, Deductable, TypeID, [Year])
values 
(1, 'Monday', 123.45, 23.05, 1, 2024),
(2, 'Tyesday', 4532.89, 654.23, 2, 2019)
go

set IDENTITY_INSERT Claims off
go