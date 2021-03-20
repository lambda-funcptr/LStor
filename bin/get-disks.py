#!/usr/bin/python3

import subprocess
import json
import argparse
import re

def get_disks(include_unsafe):
    lsblk_json = subprocess.run(["lsblk", "--json", "-O"], capture_output=True)
    unfiltered_lsblk = json.loads(lsblk_json.stdout)

    block_devices = unfiltered_lsblk["blockdevices"]

    valid_bds = filter_bds(block_devices, include_unsafe)

    print(json.dumps(list(valid_bds)))



# This function filters undesirable block devices, and if include_unsafe is not true, it will not include any block devices with children.
def filter_bds(bd_list, include_unsafe):
    filtered = []
    if not include_unsafe: 
        filtered = list(filter(lambda block_device: not block_device.has_key("children"), bd_list))
    else:
        filtered = bd_list

    # We filter out everything *except* raw block devices (e.g. /dev/sd[a-z]*)
    bd_valid_regex = re.compile("(\\/dev\\/sd[a-z]{1,})|(\\/dev\\/nvme[0-9]{1,}(n[0-9]{1,})?)")

    return list(filter(lambda block_device: bd_valid_regex.match(block_device["path"]) != None, filtered))

get_disks(True)