Use Cases
=========

The CoderDojoOS can be used in several situations.
To enable a fast update with respect to the situations,
this folder contains folders with a configuration for each
possible use-case.

Special use-cases are

- default
- local

The default use-case
--------------------

The default use-case is the one you should look for if you want to
adapt your computer to your needs.
It contains all config files and you can copy them and override
the default parameters or add new ones.
The default use-case is sourced first, so you can access the variables in it.

The local use-case
------------------

Some computers may have a special local configuration.
This configuration "local" is reserved
in case you would like to make local changes.

Add a new Use-Case
------------------

In order to add your Dojo/Programming Club or Workshop,
copy the default folder and edit the files.
Usually the files have an explanation.

Create a pull-request for your configuration!
Let others know what you are using, so the use it, too.

Files:

- `packages-to-install.txt`  
  This file contains the packages you would like to install
  with the `apt-get install` command.
  You can use comments with `#` in the file.
  If your computer has multiple use-cases, all packages will be installed.
- `users.config`  
  Here you can add new users.
  You can specify user name and password and whether they are allowed to use
  the sudo command.
- `specials-to-install.txt`  
  This is a list of special software you would like to use.
  Possible entries can be found in the [specials](../specials) folder.
  This software has a install.sh file as it is more complex to install.
  You can add your software to it.
- `homepage.config`  
  If you have a home page you would like to show when starting a browser,
  this is the file to edit.

Other configuration files are less important.
You can edit these files and add your own information.

