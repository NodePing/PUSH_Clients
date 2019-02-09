# postgresqlstat module

# Description

Queries your PostgreSQL database and sees if there is a successful query. If the query succeeeds,
then the check will pass. By default, this only gets the number of databases. The code by default
does not send the database count when pushing to NodePing. Therefore, 1 is pass and 0 is fail.

## Configuration

* Edit the pgsqlstat.txt file and set the proper username, password, etc.
  * It would be good to set this file's permissions to 0400 since it may store a password
