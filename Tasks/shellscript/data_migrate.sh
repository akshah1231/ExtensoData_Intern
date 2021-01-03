#! /bin/sh

#Dynamic Variables

hostname=localhost
username=root
password=Biplove@Jaisi
source_path=/
dest_path=/
dump_file_name=/home/biplove/Downloads/sql_hr.sql
source_ip=127.0.0.1
dest_hostname=localhost
dest_username=root
dest_password=Biplove@11825

#log file
touch log_file.txt
log=log_file.txt
 
# Name of the database

echo "Enter the name of database:"
read database_name
echo

echo $var

#Check for the database existence

mysql -h $hostname -u $username -pBiplove@Jaisi -se "Show Databases;" | grep -w "$database_name"
if [ $? -eq 0 ]
then
	echo "Database exists"
	echo Database exits.................. $(date) > $log
else
	echo "Database doesn't exists"
	echo "Database doesn't exist................" $(date) > $log
	exit 1
fi

#Check for the size of the database

database_size=$(mysql --host=$hostname --user=$username --password=$password "$database_name" -se " 
		SELECT
    			ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) AS 'size_of_database'
		FROM 
			information_schema.tables
		WHERE
    			table_schema = '$database_name'")
echo $database_size
echo "The size of the database is $database_size........" $(date) >> $log
echo

#Check for the Size of the Source Disk

disk_size=$(df -m | grep -w $source_path | awk '{print $4}')
echo $disk_size
echo "The size of the disk available  is $disk_size........" $(date) >> $log
echo

#Check whether free space for database in a source disk is available

cmd1=$(echo "$disk_size>$database_size" | bc)
if [ $cmd1 -eq 1 ];
then
	echo Free Space for Database
	echo "Free space for the export of the database to the local disk..........." $(date) >> $log
else
	echo No Free Space, Clean Up
	echo "No free space for the export of the database, you need to clean up your disk.........." $(date) >> $log
	exit 1
fi

#Ask for the destination ip address

echo "Enter the client destination ip address: "
read dest_ip_address
echo

#Information about the free space at destination

dest_disk_info=$(ssh biplove@$dest_ip_address -p 2222 "df -m | grep -w $dest_path")

#Free Space Available

dest_disk_size=$(echo $dest_disk_info | awk '{print $4}')
echo $dest_disk_size
echo "The size of the destination disk is $dest_disk_size............" $(date) >> $log
echo

#Check whether the free space in a destination disk is available

cmd2=$(echo "$dest_disk_size>$database_size" | bc)
if [ $cmd1 -eq 1 ];
then
	echo Free Space for Database Import
	echo "Free space for the import of the database at the destination disk.........." $(date) >> $log
else
	echo No Free Space, Clean Up the destination disk
	echo "No free space for the import of the database at the destination disk, you need to clean up your disk........" $(date) >> $log
	exit 1
fi

#Dump file for Sql extraction

mysqldump -u $username -h $hostname -p$password $database_name > $dump_file_name
echo "Sql dump file has been created as $dump_file_name..........." $(date) >> $log

#Transfer of database sql file to the destination server

scp -P 2222 -r $dump_file_name  biplove@$dest_ip_address:/home/biplove/Downloads 

#Create a database at the destination part

ssh biplove@$dest_ip_address -p 2222 "mysql -h $dest_hostname -u $dest_username -p$dest_password -se 'Create database $database_name;'"
echo "New database has been created at the destination disk as $database_name.........." $(date) >> $log
ssh biplove@$dest_ip_address -p 2222 "mysql -h $dest_hostname -u $dest_username -p$dest_password $database_name < $dump_file_name"
echo "Finally, the database has been imported to the destination disk. Congratulations, you are good to go............." $(date) >> $log
	
















