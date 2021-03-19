#!/usr/bin/python3

import subprocess
import json

lsblkOutput = subprocess.run(["lsblk", "--json", "-O"], capture_output=True)
unfilteredTree = json.loads(lsblkOutput.stdout)

for blockDevice in unfilteredTree:
    if blockDevice["children"] 

print(unfilteredTree["blockdevices"])
