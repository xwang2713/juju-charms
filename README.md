juju-charms
===========

HPCC Juju Charms


Usage:

1. Make sure you have juju-core and juju-local (assume you run local provider) packages installed on your Ubuntu system. If not, follow next instructions to instll them:
   1.1 sudo apt-add-respository  ppa:juju/stable
   1.2 sudo apt-get update
   1.3 sudo apt-get install juju-core
   1.4 sudo apt-get install-local

2  Generate Juju configuration if haven't do also:
   2.1 juju generate-config
   2.2 juju switch local (assume you want to run local. Default is "amazon")
2. Download this repository 
2. Deploy HPCC Charm:   juju deploy  --repository=<path of downloaded juju-charms repository>  local:precise/hpcc 
3. Check status: juju status
4. Add more HPCC nodes:  juju add-unit hpcc -n <number of node to add>  (without -n option one node will be added)
5. Check with 'juju status'. When all nodes shows "started" you can configure the cluster:
   5.1 Go to precise/hpcc/bin
   5.2 ./configure_hpcc.sh -thornodes <num of thor>  -roxienodes <num of roxie>
   5.3 The clusters should be configured and started in 1 minute. Then you can query ECLWatch URL:
       ./get_url.sh

6. To destory everthing: sudo juju destroy-environment. Run 'juju help commands' for more juju commands.  
