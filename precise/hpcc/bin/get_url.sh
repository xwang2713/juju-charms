#!/bin/bash


function get_service_information()
{
   
    
   service_info=$(python ${ABS_CWD}/parse_status.py)
   service_list=( $service_info )  
   for item in "${service_list[@]}"
   do 
       key=$(echo $item | cut -d '=' -f1)
       value=$(echo $item | cut -d '=' -f2)
       if [ "$key" = "service_name" ] 
       then
         service_name=$value
         break
       fi
   done
}


##
## Main
##################

CWD=$(dirname $0)

CUR_DIR=$(pwd)
cd $CWD
ABS_CWD=$(pwd)
cd $CUR_DIR

CHARM_NAME=$(basename $(dirname $ABS_CWD))


unit_name=$1
service_name=


if [ -z "$unit_name" ] 
then
  get_service_information
  unit_name=$(juju status | grep "${service_name}/" | \
    head -n 1 | cut -d: -f1)
fi

juju scp ${unit_name}:/etc/HPCCSystems/environment.xml /tmp  > /dev/null 2>&1

eclwatch_url_file=eclwatch_url.txt
juju scp ${unit_name}:/var/lib/juju/hpcc/$eclwatch_url_file /tmp/ > /dev/null 2>&1

echo "ECLWatch URL: $(cat /tmp/$eclwatch_url_file)"
echo "HPCC environment.xml is available under /tmp/"
