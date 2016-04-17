#!/bin/bash
#Author  : Arnab Ghosal
#GIT URL : https://github.com/arnabghosal/flat_file_gen
#Created : 17-Apr-2016
#Updated : 17-Apr-2016
#Version : 0.1.4

_ver=0.1.0

echo ""

if [ $# -eq 0 ]
then
	echo "No Options provided"
	exit 1
fi

while :
do
	case "${1}" in
		--db)
			if [[ -n "${2}" ]]
			then
				dbname="${2}"
				shift
			else
				echo "Database not specified. Use --db and specify a value"
				exit 1
			fi
		;;
		--user)
			if [[ -n "${2}" ]]
			then
				dbuser="${2}"
				shift
			else
				echo "Username not specified. Use --user and specify a value"
				exit 1
			fi
		;;
		--pass)
			if [[ -n "${2}" ]]
			then
				dbpass="${2}"
				shift
			else
				echo "Password not specified. Use --pass and specify a value"
				exit 1
			fi
		;;
		--table)
			if [[ -n "${2}" ]]
			then
				table="${2}"
				shift
			else
				echo "Table not specified. Use --table and specify a value"
				exit 1
			fi
		;;
		--schema)
			if [[ -n "${2}" ]]
			then
				schema="${2}"
				shift
			else
				echo "Schema not specified. Use --schema and specify a value"
				exit 1
			fi
		;;
		-*)
			echo "Unknown option: ${1}"
			exit 1
		;;
		--)
			break
		;;
		*)
			break
		;;
	esac
	shift
done

if [[ -z "${dbname}" ]]
then
	echo "Database not specified. Use --db and specify a value"
	exit 1
fi                                       
                                         
if [[ -z "${dbuser}" ]]                  
then                                     
	echo "Username not specified. Use --user and specify a value"
	exit 1
fi                                       
                                         
if [[ -z "${dbpass}" ]]                  
then                                     
	echo "Password not specified. Use --pass and specify a value"
	exit 1
fi

if [[ -z "${table}" ]]
then
	echo "Table not specified. Use --table and specify a value"
	exit 1
fi

if [[ -z "${schema}" ]]
then
	echo "Schema not specified. Use --schema and specify a value"
	exit 1
fi

mysqladmin ping -u"${dbuser}" -p"${dbpass}" 2>/dev/null 1>/dev/null
if [[ $? -eq 0 ]]
then 
	echo "DB Ping -> OK"
else
	echo "DB Ping -> NOK"
	exit 1
fi

mysql -u"${dbuser}" -p"${dbpass}" -e "select 1" 2>/dev/null 1>/dev/null
if [[ $? -eq 0 ]]
then 
	echo "DB Connect -> OK"
else
	echo "DB Connect -> NOK"
	exit 1
fi

echo "--------------------"
echo "File Generator Start"
echo "--------------------"
echo "Date: $(date +%d-%h-%y)"
echo "Time: $(date +%r)"
echo "Node: $(hostname)"
echo "--------------------"
echo ""

echo "Script Diagnostics"
echo "-------------------"
echo "DB        : $dbname"
echo "User      : $dbuser"
echo "Password  : $dbpass"
echo "-------------------"
echo "Schema    : $schema"
echo "Table     : $table"
echo "-------------------"
echo ""

file=/tmp/${table}.dat

db_query="select count(1) from information_schema.columns where table_schema='${schema}' and table_name='${table}'"
cnt=$(mysql -u"${dbuser}" -p"${dbpass}" -sN -e "${db_query}")
if [[ $cnt -eq 0 ]]
then
	echo "Invalid Schema and / or Table"
fi

db_extract="select * from ${schema}.${table}"
mysql -u"${dbuser}" -p"${dbpass}" -sN -e "${db_extract}" > "${file}"
if [[ $? -eq 0 ]]
then
	echo "Data Extract -> OK"
else
	echo "Data Extract -> NOK"
fi	

exit 0
