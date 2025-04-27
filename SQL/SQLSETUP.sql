USE master
GO

--CREATE DATABASE, LOGIN AND USER--
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'COFFEE_USER')
BEGIN
	CREATE LOGIN COFFEE_USER WITH PASSWORD = 'VWQKh9WP3Ctogh5KNhe9';
END

CREATE DATABASE AllTheBeans
GO

USE AllTheBeans
GO

CREATE USER COFFEE_USER FOR LOGIN COFFEE_USER WITH DEFAULT_SCHEMA = dbo;
GO

--CREATE TABLES--
CREATE TABLE COFFEEPRODUCTS (
    ID NVARCHAR(100) NOT NULL PRIMARY KEY,
    [INDEX] INT NOT NULL,
    ISBOTD BIT NOT NULL,
    COST DECIMAL(10, 2) NOT NULL,
    IMAGE NVARCHAR(500),
    COLOUR NVARCHAR(50),
    NAME NVARCHAR(100) NOT NULL,
    DESCRIPTION NVARCHAR(MAX),
    COUNTRY NVARCHAR(100)
)

grant select, update, insert, delete on dbo.COFFEEPRODUCTS to COFFEE_USER
GO

CREATE TABLE BEANOFTHEDAY (
    COFFEEPRODUCT_ID NVARCHAR(100) NOT NULL,
    FEATURED_DATE DATE NOT NULL,
    CONSTRAINT FK_BEANOFTHEDAY_COFFEEPRODUCTS FOREIGN KEY (COFFEEPRODUCT_ID) REFERENCES COFFEEPRODUCTS(ID) ON DELETE CASCADE
);

ALTER TABLE dbo.BEANOFTHEDAY
ADD CONSTRAINT UQ_BEANOFTHEDAY_FEATUREDDATE UNIQUE (FEATURED_DATE)

grant select, update, insert, delete on dbo.BEANOFTHEDAY to COFFEE_USER
GO

--CREATE PROCEDURE--
CREATE PROCEDURE [DBO].[SP_BEANOFTHEDAY] @date date
as 
begin

	declare @previous date = dateadd(day, -1, @date)
	declare @coffeeproduct_id nvarchar(100)
	declare @previouscoffeeproduct_id nvarchar(100)

	--IF RECORD FOUND FOR TODAY
	if exists(select 1 from dbo.BEANOFTHEDAY where FEATURED_DATE = @date)
	begin 
		select COFFEEPRODUCT_ID from dbo.BEANOFTHEDAY where FEATURED_DATE = @date
		return
	end
	
	--IF RECORD FOUND FOR YESTERDAY
	if exists (select 1 from dbo.BEANOFTHEDAY where FEATURED_DATE = @previous)
	begin
		set @previouscoffeeproduct_id = (select COFFEEPRODUCT_ID from dbo.BEANOFTHEDAY where FEATURED_DATE = @previous) 
		set @coffeeproduct_id = (select TOP 1 ID FROM coffeeproducts where ID <> @previouscoffeeproduct_id  ORDER BY NEWID())
	end

	--IF NOT RECORD FOUND FOR YESTERDAY
	if not exists (select 1 from dbo.BEANOFTHEDAY where FEATURED_DATE = @previous)
	begin
		--FETCH RANDOM PRODUCT ID
		set @coffeeproduct_id = (select TOP 1 ID FROM coffeeproducts ORDER BY NEWID())
	end

	insert into dbo.BEANOFTHEDAY 
	(COFFEEPRODUCT_ID, FEATURED_DATE)
	select @coffeeproduct_id, @date

	select @coffeeproduct_id
	return

END
GO

grant execute on [DBO].[SP_BEANOFTHEDAY] to COFFEE_USER

--INSERT PRODUCT DATA--
INSERT INTO coffeeproducts (id, [index], isBOTD, Cost, Image, colour, Name, Description, Country)
VALUES
('66a374596122a40616cb8599', 0, 0, '39.26', 'https://images.unsplash.com/photo-1672306319681-7b6d7ef349cf', 'dark roast', 'TURNABOUT', 'Ipsum cupidatat nisi do elit veniam Lorem magna. Ullamco qui exercitation fugiat pariatur sunt dolore Lorem magna magna pariatur minim. Officia amet incididunt ad proident. Dolore est irure ex fugiat. Voluptate sunt qui ut irure commodo excepteur enim labore incididunt quis duis. Velit anim amet tempor ut labore sint deserunt.', 'Peru'),
('66a374591a995a2b48761408', 1, 0, '18.57', 'https://images.unsplash.com/photo-1641399756770-9b0b104e67c1', 'golden', 'ISONUS', 'Dolor fugiat duis dolore ut occaecat. Excepteur nostrud velit aute dolore sint labore do eu amet. Anim adipisicing quis ut excepteur tempor magna reprehenderit non ut excepteur minim. Anim dolore eiusmod nisi nulla aliquip aliqua occaecat.', 'Vietnam'),
('66a374593ae6cb5148781b9b', 2, 0, '33.87', 'https://images.unsplash.com/photo-1522809269485-981d0c303355', 'green', 'ZILLAN', 'Cillum nostrud mollit non ad dolore ad dolore veniam. Adipisicing anim commodo fugiat aute commodo occaecat officia id officia ullamco. Dolore irure magna aliqua fugiat incididunt ullamco ea. Aliqua eu pariatur cupidatat ut.', 'Colombia'),
('66a37459771606d916a226ff', 3, 0, '17.69', 'https://images.unsplash.com/photo-1598198192305-46b0805890d3', 'dark roast', 'RONBERT', 'Et deserunt nisi in anim cillum sint voluptate proident. Est occaecat id cupidatat cupidatat ex veniam irure veniam pariatur excepteur duis labore occaecat amet. Culpa adipisicing nisi esse consequat adipisicing anim. Fugiat tempor enim ullamco sint anim qui enim. Voluptate duis proident reprehenderit et duis nisi. In consectetur nisi eu cupidatat voluptate ullamco nulla esse cupidatat dolore sit. Cupidatat laboris adipisicing ullamco mollit culpa cupidatat ex laborum consectetur consectetur.', 'Brazil'),
('66a3745945fcae53593c42e7', 4, 0, '26.53', 'https://images.unsplash.com/photo-1512568400610-62da28bc8a13', 'green', 'EARWAX', 'Labore veniam amet ipsum eu dolor. Aliquip Lorem et eiusmod exercitation. Amet ex eu deserunt labore est ex consectetur ut fugiat. Duis veniam voluptate elit consequat tempor nostrud enim mollit occaecat.', 'Vietnam'),
('66a37459591e872ce11c3b41', 5, 0, '36.56', 'https://images.unsplash.com/photo-1692299108834-038511803008', 'light roast', 'EVENTEX', 'Reprehenderit est laboris tempor quis exercitation laboris. Aute nulla aliqua consectetur nostrud ullamco cupidatat do cillum amet reprehenderit mollit non voluptate. Deserunt consectetur reprehenderit nostrud enim proident ea. Quis quis voluptate ex dolore non reprehenderit minim veniam nisi aute do incididunt voluptate. Duis aliquip commodo cupidatat anim ut ullamco eiusmod culpa velit incididunt.', 'Vietnam'),
('66a374599018ca32d01fee66', 6, 0, '22.92', 'https://images.unsplash.com/photo-1692296115158-38194aafa7df', 'green', 'NITRACYR', 'Mollit deserunt tempor qui consectetur excepteur non. Laborum voluptate voluptate laborum non magna et. Ea velit ipsum labore occaecat ea do cupidatat duis adipisicing. Ut eiusmod dolor anim et ea ea. Aliquip mollit aliqua nisi velit consequat nisi. Laborum velit anim non incididunt non qui commodo. Ea voluptate dolore pariatur eu enim.', 'Brazil'),
('66a37459cca42ce9e15676a3', 7, 0, '37.91', 'https://images.unsplash.com/photo-1522120378538-41fb9564bc75', 'medium roast', 'PARAGONIA', 'Veniam laborum consequat minim laborum mollit id ea Lorem in. Labore aliqua dolore quis sunt aliquip commodo aute excepteur. Voluptate tempor consequat pariatur do esse consectetur sunt ut mollit magna enim.', 'Colombia'),
('66a374590abf949489fb28f7', 8, 0, '17.59', 'https://images.unsplash.com/photo-1442550528053-c431ecb55509', 'golden', 'XLEEN', 'Commodo veniam voluptate elit reprehenderit incididunt. Ut laboris dolor sint cupidatat ut adipisicing. Nostrud magna labore voluptate commodo in sunt proident sunt deserunt dolor ullamco officia tempor dolor. Laboris exercitation est mollit eiusmod nostrud. Sit qui ullamco minim cillum officia irure cillum tempor eu. Et cupidatat proident amet dolore non minim.', 'Colombia'),
('66a374593a88b14d9fff0e2e', 9, 0, '25.49', 'https://images.unsplash.com/photo-1549420751-ea3f7ab42006', 'green', 'LOCAZONE', 'Deserunt consequat ea incididunt aliquip. Occaecat excepteur minim occaecat aute amet adipisicing. Tempor id veniam ipsum et tempor pariatur anim elit laboris commodo mollit. Ipsum incididunt Lorem veniam id fugiat incididunt consequat est et. Id deserunt eiusmod esse duis cupidatat Lorem. Ullamco Lorem ullamco cupidatat nostrud amet id minim ut voluptate adipisicing ipsum. Fugiat reprehenderit laborum proident eiusmod esse sint adipisicing fugiat ex.', 'Vietnam'),
('66a37459b7933d86991ce243', 10, 0, '10.27', 'https://images.unsplash.com/photo-1508690207469-5c5aebedf76d', 'light roast', 'ZYTRAC', 'Qui deserunt adipisicing nulla ad enim commodo reprehenderit id veniam consequat ut do ea officia. Incididunt ex esse cupidatat consequat. Sit incididunt ex magna sint reprehenderit id minim non.', 'Vietnam'),
('66a374592169e1bfcca2fb1c', 11, 0, '16.44', 'https://images.unsplash.com/photo-1694763768576-0c7c3af6a4d8', 'medium roast', 'FUTURIS', 'Incididunt exercitation mollit duis consectetur consequat duis culpa tempor. Fugiat nisi fugiat dolore irure in. Fugiat nulla amet dolore labore laboris sint laborum pariatur commodo amet. Ut velit sit proident fugiat cillum cupidatat ea.', 'Colombia'),
('66a37459cc0f1fb1d1a24cf0', 12, 0, '32.77', 'https://images.unsplash.com/photo-1692299108333-471157a30882', 'green', 'KLUGGER', 'Pariatur qui Lorem sunt labore Lorem nulla nulla ea excepteur Lorem cillum amet. Amet ea officia incididunt culpa non. Do reprehenderit qui eiusmod dolore est deserunt labore do et dolore eiusmod quis elit.', 'Peru'),
('66a37459caf60416d0571db4', 13, 0, '19.07', 'https://images.unsplash.com/photo-1673208127664-23a2f3b27921', 'dark roast', 'ZANITY', 'Velit quis veniam velit et sint. Irure excepteur officia ipsum sint. Est ipsum pariatur exercitation voluptate commodo. Ex irure commodo exercitation labore nulla qui dolore ad quis.', 'Honduras'),
('66a3745997fa4069ce1b418f', 14, 0, '29.42', 'https://images.unsplash.com/photo-1544486864-3087e2e20d91', 'green', 'XEREX', 'Esse ad eiusmod eiusmod nisi cillum magna quis non voluptate nulla est labore in sunt. Magna aliqua pariatur commodo deserunt. Pariatur pariatur pariatur id excepteur ex elit veniam.', 'Brazil');



