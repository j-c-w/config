#!/bin/bash

find -L -type d -wholename "*$@*" 2> /dev/null | fzf
