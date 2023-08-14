#!/bin/bash
set -e

module purge
module load amber


## npt qmmm
cnt=1
cntmax=10

prefix=npt_qmmm
while [ $cnt -le $cntmax ];
do
    pcnt=$(( $cnt - 1 ))
    istep="${prefix}_${cnt}"
    pstep="${prefix}_${pcnt}"

    if [ -e ${istep}.rst7 ]; then
        echo "[INFO] ${istep} was skipped" >&1
        cnt=$(( $cnt + 1 ))
        continue
    fi

    if [ $cnt -eq 1 ]; then
        pstep="npt_md"
        # pstep="min_qmmm"
    fi

    mpirun sander.MPI -O \
        -i ${prefix}.in \
        -p cm.parm7 \
        -c ${pstep}.rst7 \
        -o ${istep}.mdout \
        -r ${istep}.rst7 \
        -inf ${istep}.mdinfo \
        -x ${istep}.nc
    cnt=$(( $cnt + 1 ))
    echo "[INFO] ${istep} done" >&1
done

echo "[INFO] npt qmmm done" >&1
