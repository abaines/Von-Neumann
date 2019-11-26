# Alan Baines

import os.path
import os
import threading
import hashlib
import shutil
import winsound
import time
import glob
import re
import zipfile
import datetime
import tempfile
import sys
import traceback

root = os.path.dirname(os.path.abspath(__file__))
print( root )


def getAllFiles(directory):
   r = []
   for path, subdirs, files in os.walk(root):
      for name in files:
         f = os.path.join(path, name)
         r.append(f)
   return r

for file in getAllFiles(root):
   if '\\.git\\' not in file:
      print(file[len(root):])
