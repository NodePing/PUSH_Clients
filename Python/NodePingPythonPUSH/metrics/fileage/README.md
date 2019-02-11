# fileage module

## Description

Checks any files on your computer to see if they are older than a specified age. The check will fail if the file is too old or if the file goes missing.

## Configuration

* Edit the config.py file `filenames` dictionary
  * The key is the filename
  * For Windows systems, be sure to put an r at the beginning of the pathname like r'C:\path\to\file' so Python interprets the path as a raw string
  * Set the days, hours, minutes values to whatever you wish
