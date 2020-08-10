#!/bin/bash

ps -ef | grep mysqld_exporter | awk '{print $2}' | xargs kill -9
