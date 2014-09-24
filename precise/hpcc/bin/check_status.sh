#!/bin/bash

function usage()
{
   cat <<EOF

    Check HPCC Juju Charm status
    Usage:  $(basename $0) <options>
    where
       -name <service name> :
          Juju charm service name. Then name can be provided at charm
          deploy name. The default is the same as charm name.  This will
          identify HPCC cluster.

EOF
}

function get_service_information()
{
   _options=

   [ -n "${service[service_name]}" ] && _options="-s ${service[service_name]}"

   service_info=$(python ${ABS_CWD}/parse_status.py $_options)
   service_list=( $service_info )
   for item in "${service_list[@]}"
   do
       key=$(echo $item | cut -d '=' -f1)
       value=$(echo $item | cut -d '=' -f2)
       [ -n "$key" ] && service["$key"]=$value
   done
}

function get_current_config()
{
   juju get ${service[service_name]} > /tmp/${service[service_name]}.cfg
   config_info=$(python ${CWD}/parse_config.py /tmp/${service[service_name]}.cfg)
   config_list=( $config_info )
   for item in "${config_list[@]}"
   do
       key=$(echo $item | cut -d '=' -f1)
       value=$(echo $item | cut -d '=' -f2)
       [ -n "$key" ] && config["$key"]=$value
   done

}

function check_installed_version()
{
   expected_version=$(echo ${config[hpcc-version]} | sed 's/-//')

   unit_name=$(juju status | grep -e "^[[:space:]]*${service[service_name]}/" | \
      /usr/bin/head -n 1 | cut -d: -f1 | sed 's/\s//g')

   tmp_file=/tmp/hpcc_version
   if [ "$Distributor_ID" == "Ubuntu" ]
   then
      juju ssh ${unit_name} "dpkg -l | grep hpccsystems-platform" > $tmp_file 2>&1
   else
      juju ssh ${unit_name} "rpm -qi hpccsystems-platform | grep -e \"^Release \"" > $tmp_file 2>&1
   fi

   hpcc_version=$(cat $tmp_file | tail -n 2 | head -n 1 | awk '{print $3}')
   if [ "$expected_version" = "$hpcc_version" ]
   then
      printf "%s%-20s: %-20s\n" "$INDENT" "HPCC Version" "${config[hpcc-version]}"
   else
      printf "\n%s%s\n" "Expected HPCC version ${config[hpcc-version]} doesn't been installed yet."
      printf "%s%s\n" "Current version ${hpcc_version]}"
      exit 1
   fi
   rm -rf $tmp_file
}

function check_hpcc_status()
{
   tmp_file=/tmp/hpcc_status
   echo $hpcc_version | grep -q "^4\." 
   if [ $? -eq 0 ]
   then
       juju ssh ${unit_name} "sudo /opt/HPCCSystems/sbin/hpcc-run.sh status" > $tmp_file 2>&1
   else
       juju ssh ${unit_name} "sudo /opt/HPCCSystems/sbin/hpcc-run.sh -S status" > $tmp_file 2>&1
   fi
   
   nodes_in_cluster=$(cat $tmp_file | grep -e "^mydafilesrv" | wc -l)
   if [ $nodes_in_cluster -eq ${service[unit_number]} ]
   then
      printf "%s%-20s: %-20s\n" "$INDENT" "Nodes in cluster" "${nodes_in_cluster}"
   else
      printf "%s%s\n" "$INDENT" "Not all the nodes join yet. Here are ${nodes_in_cluster} node(s) in the cluster now."
      exit 1
   fi

   nodes_stopped=$(cat $tmp_file | grep stopped | wc -l )
   if [ $nodes_stopped -eq 0 ]
   then
      printf "\n%s%s\n" "$INDENT" "All HPCC processes are running."
   else
      printf "\n%s%s\n" "$INDENT" "Some HPCC processes stopped. See $tmp_file for detail."
      exit 1
   fi

   cat $tmp_file | grep -q -e "^mythor" 
   [ $? -eq 0 ] && has_thor_node=1

   rm -rf $tmp_file
   
}

function check_thor_slaves_status()
{
   tmp_file=/tmp/thor_sentinel.txt
   juju ssh ${unit_name} "sudo ls /var/lib/HPCCSystems/mythor/*" > $tmp_file 2>&1
   cat $tmp_file | grep -q "thor.sentinel" 
   if [ $? -eq 0 ]
   then
      printf "%s%s\n\n" "$INDENT" "All thor slave nodes are ready."
   else
      printf "\n%s%s\n\n" "$INDENT" "Some thor slave nodes may not be ready. Wait a few seconds and try it again."
      exit 1
   fi
   rm -rf $tmp_file
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


declare -A config
declare -A service
service[service_name]=
has_thor_node=0

INDENT="    "


num_args=$#
for ((i=1; i<=num_args; i++))
do
  case $1 in
    -name) shift
            i=$(expr $i \+ 1)
            service[service_name]=$1
            ;;
    *) usage
       exit 0
  esac
  shift
done

Distributor_ID=$(lsb_release -a 2>/dev/null | grep  "Distributor ID:" | \
  sed -n "s/.*:[[:space:]]*\(.*\)/\1/p")

get_service_information
get_current_config


printf "\n"
printf "%s%-20s: %-20s\n" "$INDENT" "CHARM NAME" "$CHARM_NAME"
printf "%s%-20s: %-20s\n" "$INDENT" "SERVICE NAME" "${service[service_name]}"
printf "%s%-20s: %-20s\n" "$INDENT" "UNIT NUMBER" "${service[unit_number]}"
check_installed_version
check_hpcc_status
if [ $has_thor_node -eq 1 ]
then
   check_thor_slaves_status
fi
