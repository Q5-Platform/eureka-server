#!/bin/sh
echo y | fly -t do sp -p blog-eureka-server -c pipeline.yml -l ../../credentials.yml
