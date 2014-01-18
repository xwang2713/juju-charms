juju-charms
===========

HPCC Juju Charms


Usage:

1. Make sure you have juju-core and juju-local (assume you run local provider) packages installed on your Ubuntu system. If not, follow next instructions to instll them:
1a. sudo apt-add-respository  ppa:juju/stable.
1b. sudo apt-get update.
1c. sudo apt-get install juju-core.
1d. sudo apt-get install-local.

2. Generate Juju configuration if haven't do also:
2a juju generate-config
2b juju switch local (assume you want to run local. Default is "amazon")

3. Download this repository 
4. Deploy HPCC Charm:   juju deploy  --repository=<path of downloaded juju-charms repository>  local:precise/hpcc 
5. Check status: juju status
6. Add more HPCC nodes:  juju add-unit hpcc -n <number of node to add>  (without -n option one node will be added). By default, if total number of nodes is N the cluster will be configured as: 1 support node, N-1 thor processes, and N-1 roxie nodes.Check with 'juju status'. Make sure all of them show state "started"
7. Re-configure the cluster
7a Going to precise/hpcc/bin
7b ./configure_hpcc.sh -thornodes <num of thor>  -roxienodes <num of roxie>
7c The clusters should be configured and started in 1 minute. Then you can query ECLWatch URL: ./get_url.sh
8. To destory everthing: sudo juju destroy-environment. Run 'juju help commands' for more juju commands.  
