#!/bin/bash

ghdl --clean

ghdl -a *.vhdl

ghdl -r tb_neander --wave=tb_neander.ghw --stop-time=10000ns

gtkwave -f tb_neander.gtkw &