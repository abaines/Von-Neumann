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



whitelist=[
"\\README.md",
"\\changelog.txt",
"\\data.lua",
"\\graphics\\hr_character_running_gun.png",
"\\graphics\\hr_character_running_gun_mask.png",
"\\info.json",
"\\license.md",
"\\locale\\en\\locale.cfg",
#"\\retreatDecon.txt",
"\\scenarios\\Von Neumann\\control.lua",
"\\scenarios\\Von Neumann\\daddy.png",
"\\scenarios\\Von Neumann\\hijack.lua",
"\\scenarios\\Von Neumann\\locale\\en\\freeplay.cfg",
"\\scenarios\\Von Neumann\\locale\\en\\vonNeumann.cfg",
"\\scenarios\\Von Neumann\\playerBonuses.lua",
"\\scenarios\\Von Neumann\\railbot.lua",
"\\scenarios\\Von Neumann\\vonNeumann.lua",
"\\thumbnail.png",
#"\\zipper.py",
"\\companionship.lua",
"\\control.lua",
"\\settings.lua",
"\\locale\\en\\config.cfg",
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

def collectWhiteListFiles(root,whitelist):
   returns = []
   ignored = []

   for file in getAllFiles(root):
      shortname = file[len(root):]
      if endsWithAny(file,whitelist):
         returns.append(shortname)
      elif '\\.git\\' in file:
         pass
      else:
         ignored.append(shortname)

   return returns, ignored


def printWhiteListFiles(root):
   print("")
   print(root)
   print("ignored")
   r,i = collectWhiteListFiles(root,whitelist)
   for f in i:
      print(f)
   print("whitelist")
   for f in r:
      print(f)

printWhiteListFiles("..\\vonNeumann_0.2.22")
printWhiteListFiles("..\\lightArtillery_0.1.4")
printWhiteListFiles("..\\companionship_0.0.6")
