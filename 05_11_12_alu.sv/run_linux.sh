#!/bin/bash

iverilog -g2005-sv -o out.vvp *.sv *.svh prefix_adder/*.sv
vvp out.vvp
