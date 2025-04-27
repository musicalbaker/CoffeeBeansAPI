# All The Beans - CoffeeBeanAPI

# Technologies 
- VS 2022
- .NET CORE 8. The latest supported version of .NET CORE
- SQL SERVER - A common relational database. I've used it extensively and had an instance ready to use. 
- Entity Framework - Reliable library to handle the ORM and database interaction.   

- 
# Considerations
I started with a data first approach, based on the JSON data. Some JSON fields were modified when inserted into SQL server.
Modifications are detailed below.

- Changed id keep convention
"_id" --> "id" 

- Changed cost from string to decimal, limited to 2 decimal points. For future use in calculations.
"£17.69" --> 17.69


- No status field present. In this project the API delete removes it from the database. Given more time I would 
- add a status field, so that deleting a product would mark it as inactive. In case that data is needed in future.

{
    "id": "66a37459771606d916a226ff",
    "index": 3,
    "isBOTD": false,
    "Cost": 17.69,
    "Image": "https://images.unsplash.com/photo-1598198192305-46b0805890d3",
    "colour": "dark roast",
    "Name": "RONBERT",
    "Description": "Et deserunt nisi in anim cillum sint voluptate proident. Est occaecat id cupidatat cupidatat ex veniam irure veniam pariatur excepteur duis labore occaecat amet. Culpa adipisicing nisi esse consequat adipisicing anim. Fugiat tempor enim ullamco sint anim qui enim. Voluptate duis proident reprehenderit et duis nisi. In consectetur nisi eu cupidatat voluptate ullamco nulla esse cupidatat dolore sit. Cupidatat laboris adipisicing ullamco mollit culpa cupidatat ex laborum consectetur consectetur.\r\n",
    "Country": "Brazil"
  }

Added a BEANOFTHEDAY table to keep the history. May be useful for future analysis. 

- 3.	Implement business logic to ensure:
•	Each day, a new "Bean of the Day" is selected randomly from the available beans.
•	The selected bean cannot be the same as the previous day.

Added a BEANOFTHEDAY table to keep the history. This does make the isBOTD field redundant, so it is set to false for all records.  
The stored procedure [SP_BEANOFTHEDAY] will work for any day, past or future for maximum flexiblity. 
The assumption is that whatever application is calling the API beanoftheday would be passing the current date. 



4.	Implement a database search feature to show products available

 1. If no match found for the search term, it returns no products. 
 2. Can search by the following coffee bean properties: name, colour,description, country
 3. It currently search by one field at a time. In future, it would be modified into a combined search. 


# Instructions
- Create a SQL Server 2019+ instance 
- Run the SLQSETUP.sql file as admin to create the database and insert the data. 

- Change the connection string in appsettings.json to match.
  "CoffeeProductContext": "data source={SQLSERVER};initial catalog=AllTheBeans;user Id=COFFEE_USER;Password=VWQKh9WP3Ctogh5KNhe9;TrustServerCertificate=True"
  
- Run the project from visual studio and try the API!

