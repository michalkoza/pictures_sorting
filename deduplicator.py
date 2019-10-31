#!/usr/bin/python3

import os
import re
from optparse import OptionParser
import json

def parse_path(work_folder, reference_folder, verbose=False):
    print (work_folder)
    for path, dirs, files, in os.walk(work_folder):
        print (path)
        for f in files:
            datafile = os.path.join(path, f)
            #print datafile
            print (datafile)


def main():
    usage = "usage: %prog [options] arg"
    parser = OptionParser(usage)
    parser.add_option("-t", "--target", dest="target",
                      default="/Volumes/mk_green/_MyData/MEDIA/My Pictures/",
                      help="Path to sorted pictures folder. This path will not be altered")
    parser.add_option("-p", "--path", dest="path", default="~/Documents/_do_sortowania",
                      help="Path to folder with new pictures. The pictures will be checked against target folder and all pictures that are already present in target folder will be removed from this folder.")
    parser.add_option("-v", "--verbose", action="store_true", dest="verbose", default=False,
                      help="If true, prints warnings")
    (options, args) = parser.parse_args()
    print ("")
    parse_path(options.path, options.target, options.verbose)

if __name__ == "__main__":
    main()
