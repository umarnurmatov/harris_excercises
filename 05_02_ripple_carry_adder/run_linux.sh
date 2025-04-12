#!/bin/bash

iverilog -g2005-sv -o out.vvp *.sv
vvp out.vvp
