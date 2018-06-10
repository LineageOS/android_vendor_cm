#!/usr/bin/env python

from __future__ import print_function

import argparse
import os
import sys


def extract(transfer_list_path, new_dat_path, output_path):
    block_size = 0x1000
    with open(transfer_list_path, 'r') as transfer_list, \
            open(new_dat_path, 'rb') as src, \
            open(output_path, 'wb') as dst:
        version = int(transfer_list.readline())
        total_blocks = int(transfer_list.readline())
        if version >= 2:
            # how many stash entries are needed simultaneously
            transfer_list.readline()
            # maximum number of blocks that will be stashed simultaneously
            transfer_list.readline()

        last_block = 0
        blocks_written = 0
        for line in transfer_list:
            line = line.strip()
            if not line:
                continue

            cmd, arg = line.split(' ', 1)
            if cmd == "new":
                ranges = [int(i) for i in arg.split(',')[1:]]
                for begin, end in zip(ranges[::2], ranges[1::2]):
                    blocks_count = end - begin
                    dst.seek(begin * block_size)
                    dst.write(src.read(blocks_count * block_size))
                    blocks_written += blocks_count
                    last_block = max(last_block, end)
            elif cmd == "zero":
                ranges = [int(i) for i in arg.split(',')[1:]]
                for begin, end in zip(ranges[::2], ranges[1::2]):
                    blocks_written += end - begin
                    last_block = max(last_block, end)
            elif cmd == "erase":
                # Nothing to do
                pass
            else:
                print("'{}' is not a supported command".format(cmd),
                      file=sys.stderr)

        dst.truncate(last_block * block_size)

    if total_blocks != blocks_written:
        print("Warning: {}/{} blocks written".format(
            blocks_written, total_blocks), file=sys.stderr)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("transfer_list",
                        help="Path to the system.transfer.list file")
    parser.add_argument("new_dat",
                        help="Path to the system.new.dat file")
    parser.add_argument("output_path", nargs="?", default="system.img",
                        help="Output file")
    parser.add_argument("--force", "-f", action="store_true",
                        help="Overwrite output file")
    args = parser.parse_args()
    if os.path.exists(args.output_path) and not args.force:
        print("Specify a different path or use --force")
        exit(1)
    extract(args.transfer_list, args.new_dat, args.output_path)
