#! /bin/sh

username=root
password=Biplove@Jaisi
hostname=localhost

echo "Enter the name of database you want to use"
read database_name

echo "Enter the table name"
read table_name

mysql -u$username -p$password -h$hostname -se "Show databases;" | grep -w "$database_name"

if [ $? -eq 0 ];
then
	echo "Database exists"
else {
	echo "Database doesn't exists"
}
fi

if [ $(mysql -u root -pBiplove@Jaisi -se "select count(*) from information_schema.tables where table_schema='$database_name' and table_name='$table_name';") -eq 1 ];
then
	echo "Table exists"
else {
	echo "Table doesn't exist"
}
fi

#Note by default, the secure_file_priv has the following location so csv will go into that location
#To see we can do show variables like "secure_file_priv"
mysql -uroot -pBiplove@Jaisi -e "use $database_name;select * into outfile '/var/lib/mysql-files/sql.csv' fields terminated by ',' optionally enclosed by '\"' lines terminated by '\n' from $table_name;"

sudo mailx -s "CSV file has been exported and send to respective gmail" -a /var/lib/mysql-files/sql.csv `cat /home/emails.txt`


