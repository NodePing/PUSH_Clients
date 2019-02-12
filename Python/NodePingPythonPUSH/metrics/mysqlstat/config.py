# Database user that would be used for the -u argument
username = 'mysql'

# Host that would be used for the -h argument
host = 'localhost'

unix_socket = ''

# Password used to query a database, used for the -p argument
password = ''

# Query to run on the database. The query should return a numeric value
querystring = 'SELECT * FROM information_schema.SCHEMATA'

# Does not return the number of databases if False. This is in case you
# Don't want to send the actual database count but want to see if a query happens
return_db_count = False
