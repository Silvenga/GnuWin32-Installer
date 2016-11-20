@echo off
set "LESSOPEN=|gzip -cdfq %%s"
less %*
set LESSOPEN=

