import sys
import yaml

config_file = sys.argv[1]
stream = file(config_file, "r")
config = yaml.load(stream)

config_options = [ 'roxie-ratio',
                   'slaves-per-node',
                   'support-nodes',
                   'thor-ratio',
                   'hpcc-version',
                   'package-checksum'
                 ]

for option in config_options:
  try:
      value = config["settings"][option]["value"]
  except:
      value = ""
  print (option + "=" + str(value))
