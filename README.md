
This repo contains scripts to test energy consumption of AMD EPYC 7532 derived from [a blog post about AMD EPYC 7313P](https://metebalci.com/blog/epyc-energy-consumption-test/).

# test.sh 

`test.sh` runs various tests and generates output files. It should be run in an empty directory because it generates many files.

turbostat measurement interval and stress timeout can be configured at the top of the script.

It generates various output files named $pstate-$config.info and $pstate-$config.out, for example P2-1.out. The info file is `cpupower frequency-info` output and out file is the `turbostat` output of the test run.

# parse.sh 

`parse.sh` parses the out files and generates a markdown formatted table. For AMD EPYC 7532 it was generated as `table.md`.
