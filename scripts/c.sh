#!/bin/bash

find -type d -wholename "*$@*" 2> /dev/null | fzf
