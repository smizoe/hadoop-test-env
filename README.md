Hadoop Environment for Testing Purpose
======================================

This repository contains a pair of Dockerfile and ansible playbook
that builds a docker image with hadoop environment (hadoop, hive, hbase) installed.

You can build an image and attach to a container by running:

```
$ ./run.sh # by default, this creates a image named 'hadoop_test_env'
```
