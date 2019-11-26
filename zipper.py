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

rootx = os.path.dirname(os.path.abspath(__file__))
print( rootx )

whitelistextensions=[
".cfg",
".lua",
]

whitelist=[
"\\README.md",
"\\changelog.txt",
"\\info.json",
"\\license.md",
"\\thumbnail.png",
]

whitelistextensionsinsidefolders=[
".png",
]



def getAllFiles(directory):
   returns = []
   for path, subdirs, files in os.walk(directory):
      for name in files:
         f = os.path.join(path, name)
         returns.append(f)
   return returns

def endsWithAny(text,collection):
   for c in collection:
      if text.endswith(c):
         return c
   return False

def collectWhiteListFiles(root,whitelist,whitelistextensions,whitelistextensionsinsidefolders):
   returns = []
   ignored = []

   for file in getAllFiles(root):
      shortname = file[len(root):]
      c = shortname.count('\\')
      if endsWithAny(file,whitelist):
         returns.append(shortname)
      elif endsWithAny(file,whitelistextensions):
         returns.append(shortname)
      elif c >= 2 and endsWithAny(file,whitelistextensionsinsidefolders):
         returns.append(shortname)
      elif '\\.git\\' in file:
         pass
      else:
         ignored.append(shortname)

   return returns, ignored


def setExtensions(listFiles):
   s = set()
   for f in listFiles:
      e = f[f.rindex('.')+1:]
      s.add(e)
   return s

def printWhiteListFiles(root):
   print("")
   print(root)
   r,i = collectWhiteListFiles(root,whitelist,whitelistextensions,whitelistextensionsinsidefolders)
   
   if len(i)>0:
      print ('{:-^80}'.format('ignored'))
      for f in i:
         print(f)
      print(setExtensions(i))
      
   print ('{:=^80}'.format('white'))
   for f in r:
      print(f)
   print(setExtensions(r))

printWhiteListFiles("..\\vonNeumann_0.2.22")
printWhiteListFiles("..\\lightArtillery_0.1.4")
printWhiteListFiles("..\\companionship_0.0.6")
