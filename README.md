# CoderDojoOS
We customize an Ubuntu to use in the CoderDojos

Why?

- Computers in CoderDojos need special software, if it is pre-installed, kids can code more, save time.
- The projects of the kids can be saved and uploaded so we can show-case them and continue at home.

What is included?

- a specialized install for each dojo.
- automatic, asynchronous updates:
  1. push to github
  2. start the computer, it logs into wifi
  3. it updates
- [special packages](specials) like
  - [aiStarter](specials/app-inventor-starter)
  - [issues for more packages](https://github.com/CoderDojoPotsdam/CoderDojoOS/issues?q=is%3Aopen+is%3Aissue+label%3Aspecial)

## Installation

If you have setup an Ubuntu 16, you can open the command line and do

    wget -O- https://raw.githubusercontent.com/CoderDojoPotsdam/CoderDojoOS/master/install_coderdojoos.sh | /bin/bash

This guides you through the installation process. And you are done.

## Configure a new Dojo

In the CoderDojoOS directory, you should see a file `use-cases-default.txt`
This is the file which has the default use-cases in it.
These are all folders in the [use-cases](use-cases) folder.
Read there on how to add a new dojo.

## Test that it works

So see if the CoderDojoOS is executed properly on startup, you can view the log files once you restarted:

    cat /opt/coderdojoos/all.log

It should look something like this: 

    Starting up Thu Dec 15 03:43:30 PST 2016
    Step 40_wait_for_internet_connection.sh ... ok
    Step 45_install_packages.sh ... ok
    Step 47_add_git_remotes.sh ... ok
    Step 50_update.sh ... ok
    Step 52_install_packages.sh ... ok
    Step 60_create_users_and_groups.sh ... ok
    Step 70_install_specials.sh ... ok
    Done.

