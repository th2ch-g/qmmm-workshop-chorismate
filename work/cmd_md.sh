#!/bin/bash
set -e

module purge
module load amber

# MD
## minimization
# mpirun sander.MPI -O \
pmemd.cuda -O \
    -i min_md.in \
    -p cm.parm7 \
    -c cm.rst7 \
    -o min_md.mdout \
    -r min_md.rst7 \
    -inf min_md.mdinfo \
    -ref cm.rst7
echo "[INFO] mini done" >&1

## nvt
# mpirun sander.MPI -O \
pmemd.cuda -O \
    -i nvt_md.in \
    -p cm.parm7 \
    -c min_md.rst7 \
    -o nvt_md.mdout \
    -r nvt_md.rst7 \
    -inf nvt_md.mdinfo \
    -ref cm.rst7 \
    -x nvt_md.nc
echo "[INFO] nvt done" >&1

## npt
# mpirun sander.MPI -O \
pmemd.cuda -O \
    -i npt_md.in \
    -p cm.parm7 \
    -c nvt_md.rst7 \
    -o npt_md.mdout \
    -r npt_md.rst7 \
    -inf npt_md.mdinfo \
    -ref cm.rst7 \
    -x npt_md.nc
echo "[INFO] npt done" >&1
