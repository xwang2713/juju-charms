# Overview

[HPCC](http://HPCCSystems.com) (High Performance Computing Cluster) is a massive parallel-processing computing platform that solves Big Data problems. HPCC is a proven and battle-tested platform for manipulating, transforming, querying, and data warehousing Big Data.

The HPCC Systems architecture incorporates Thor and Roxie clusters, as well as common middleware support components, an external communications layer, client interfaces which provide both end-user services and system management tools, and auxiliary components to support monitoring and to facilitate loading and storing of file system data from external sources.  
  
An HPCC environment can include only Thor clusters, or both Thor and Roxie clusters. The HPCC Juju charm creates a cluster which contains both, but you can customize it after deployment.
 
See [How it Works](http://www.hpccsystems.com/Why-HPCC/How-it-works)  for more details. 

The HPCC Juju Charm encapsulates best practice configurations for the HPCC Platform.  You can use a Juju charm to stand up an HPCC Platform on:

- Local Provider (LXC)

- Amazon Web Services Cloud
 
# Usage

## General Usage

1. To deploy an HPCC Cluster:

    `juju deploy hpcc <cluster_name>`

	***For example:***

	`juju deploy hpcc cluster1`

1. To check the status , run 
	juju status  
	
	You also can log into the node to check if HPCC is properly installed. 

	`juju ssh cluster1/0` 

1.  Once HPCC is properly installed, you can add more nodes using this command:
 
	`juju add-unit -n <#_of_nodes_to_add>`


1. You can expose the HPCC cluster by running:

	`juju expose <cluster_name>` 


# Configuration

After deploying and adding nodes, you can tweak various options to optimize your HPCC deployment to meet your needs. 

See [HPCC Systems Web site](http://HPCCSystems.com) for more details. 
 

# HPCC Systems Contact Information

[HPCC Systems Web site](http://HPCCSystems.com)

For support, visit the HPCC Community Forums: 
[HPCC Community Forums](http://hpccsystems.com/bb/index.php?sid=0bda2dddb2ea50418357171d33b11e5f)