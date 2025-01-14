#!/usr/bin/env python3

import os
import sys


sys.path.insert(0, '.')

# This is needed to find resources when using pyinstaller
if getattr(sys, 'frozen', False):
    basedir = getattr(sys, '_MEIPASS', '')
else:
    basedir = os.path.dirname(os.path.abspath(__file__))

if sys.platform == 'win32':
    os.environ['PATH'] = basedir + ';' + os.environ['PATH']

from picard.tagger import main
main(os.path.join(basedir, 'locale'), True)
