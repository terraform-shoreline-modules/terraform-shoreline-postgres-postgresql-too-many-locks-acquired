
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Postgresql too many locks acquired
---

This incident type occurs when there are too many locks acquired on a Postgresql database instance. This can cause issues with database performance and functionality. It may be necessary to adjust the max_locks_per_transaction setting in Postgresql to prevent this issue from occurring.

### Parameters
```shell
# Environment Variables

export POSTGRESQL_LOG="PLACEHOLDER"

export NEW_MAX_LOCKS="PLACEHOLDER"

export DATABASE_HOST="PLACEHOLDER"

export DATABASE_PASSWORD="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DATABASE_USER="PLACEHOLDER"

```

## Debug

### Check the status of the Postgresql service
```shell
systemctl status postgresql
```

### Check the status of the Postgresql server
```shell
ps aux | grep postgres
```

### Check the number of locks acquired per transaction in the Postgresql database
```shell
sudo su postgres -c "psql -c 'SELECT * FROM pg_locks;'"
```

### Check the value of the max_locks_per_transaction setting in the Postgresql configuration file
```shell
sudo cat   /etc/postgresql/main/postgresql.conf | grep max_locks_per_transaction
```

### Check the Postgresql logs for any relevant error messages
```shell
sudo tail -n 100 ${POSTGRESQL_LOG}
```

### A database query is acquiring a large number of locks, causing the lock limit to be exceeded.
```shell
bash

#!/bin/bash



# This script diagnoses the scenario where a database query is acquiring a large number of locks, causing the lock limit to be exceeded.



# Set the database credentials

DB_HOST=${DATABASE_HOST}

DB_NAME=${DATABASE_NAME}

DB_USER=${DATABASE_USER}

DB_PASSWORD=${DATABASE_PASSWORD}



# Connect to the database and run a query to check the number of locks

locks=$(psql -h $DB_HOST -d $DB_NAME -U $DB_USER -c "SELECT COUNT(*) FROM pg_locks")



# Check if the number of locks is above a threshold

if [ $locks -gt 1000 ]

then

  echo "Number of locks is above threshold: $locks"

  echo "Please investigate the queries running on the database to identify the cause of the excessive locks."

else

  echo "Number of locks is within acceptable range: $locks"

fi


```

## Repair

### Set the new value for max_locks_per_transaction
```shell
NEW_MAX_LOCKS=${NEW_MAX_LOCKS}
```

### Update the postgresql.conf file with the new value
```shell
sudo sed -i "s/^max_locks_per_transaction = [0-9]\+$/max_locks_per_transaction = $NEW_MAX_LOCKS/" /etc/postgresql/main/postgresql.conf
```

### Restart the Postgresql service
```shell
sudo systemctl restart postgresql
```