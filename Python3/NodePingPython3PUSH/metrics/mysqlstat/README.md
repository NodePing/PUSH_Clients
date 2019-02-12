# mysqlstat module

## Description

Queries your MySQL/MariaDB and sees if there is a successful query. If the query succeeds,
then the check will pass. By default, this only gets the number of databases. The code by default
does not send the database count when pushing to NodePing. Therefore, 1 is pass and 0 is fail.

## Configuration

* Edit the config.py file and modify as needed
  * Set the proper username
  * Set the proper password
  * Set the proper querystring (or keep default)
	* If modifying the querystring, the mysqlstat.py file may need modification to work with the custom query
  * Set the `return_db_count` variable to True if you want to return the database count to NodePing		
