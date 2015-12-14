#!/bin/bash

# sampling freq
FS=1
#FS=10

die() { echo -e "ERROR: $@ !" >&2; exit 1; }

if [ X"$1" = X ]; then
    echo "$0 {[-s]} [file from logger]"
    echo " Flags:"
    echo "   -s    don't plot, just dump data to console"
    exit 1
fi
stream=0
case X"$1" in
    X-s)    stream=1;shift;;
esac

########################################################
fn=''
fntxt=''
while [ ! -z $1 -a -f $1 ]; do
    fg="$(echo "$1" | tr '[_/]' '-')"
    fn="${fn}$1 "
    fntxt="${fntxt}${fg} "
    shift
done
echo "# DEBUG: input file(s):$fn"
########################################################
# freq = 1
if cat $fn | grep -aq "^# freq =" &>/dev/null; then
    FS="`cat $fn | grep -a "^# freq =" | awk '{print $4}'`"
fi
FS_inv="`echo "1.0/$FS" | bc -l`"
########################################################
# compute length of day
lns=`cat $fn | awk '($1*$2) > 500' | wc -l` # TODO
hrs="`echo "$lns" | awk '{printf("%0.2f\n",$1/3600)}'`"
echo "# Day length for $fn = $hrs hours"
# how many data segments exist?
datapts=`cat $fn | grep '^# ad' | wc -l | awk '{print $1}'`
echo "# Data points = $datapts"
########################################################
dt="`date +%m%d%y`"
COMMENT_TEXT=''  # set -C opt arg to plotit.pl, eg ':sensor1:sens2'
# NOTE: assumes $4 is Vbat divided by 2
get_data_from_file_prepend_FS_inv() { grep -av ^# $@ | prepend_time.pl -t $FS_inv | awk '{print $1" "($2*(3.3/1024))" "($3*(3.3/1024))" "($4*(3.3/1024)*2)}'; }
#mk_plotit_call() { echo -e "\nmk_plotit_call: opening $fn..." && plotit.pl -n -Lx "Seconds" -Ly "SolarPanelVolts" -T "${dt}-SolarPanelInSouthWindow-$fntxt" -C "$COMMENT_TEXT" -t 3600 $@; }
mk_plotit_call() {
    if [ $stream -eq 1 ]; then
        cat -
    else
        echo -e "\nmk_plotit_call: opening $fn..."
        plotit.pl -Lx "Seconds" -Ly "SolarPanelVolts" -T "${dt}-SolarPanelInSouthWindow-$fntxt" -C "$COMMENT_TEXT" -p $@
    fi
}

########################################################

T=`mktemp /tmp/tmp.XXXXXXXX`
get_data_from_file_prepend_FS_inv $fn > $T

# plot
if [ $datapts -eq 1 ]; then
    #
    # just solar panel
    #
    COMMENT_TEXT=':SolarPanel'
    cat $T | awk '{print $1" "$2}' | mk_plotit_call $@

#elif [ $datapts -eq 2 ]; then
else
    #
    # solar panel & photocell
    #

# DEV:
#    COMMENT_TEXT=':SolarPanel:PhotoCell:Solar*Photo:Solar+Photo:Solar/Photo:Solar*Photo'
#    cat $T | awk '{print $1" "$2":"$3":"$2+$3":"$2/$3":"$2*$3}' | mk_plotit_call $@

# OUTPUT MANY PLOTS!
#    COMMENT_TEXT=':SolarCell'
#    cat $T |  awk '{print $1" "$2}' | mk_plotit_call $@ &
#    COMMENT_TEXT=':PhotoCell'
#    cat $T |  awk '{print $1" "$3}' | mk_plotit_call $@ &
#    COMMENT_TEXT='Photo/Solar'
#    cat $T |  awk '{print $1" "$3/$2}' | mk_plotit_call $@ &
#    COMMENT_TEXT=':Solar/Photo'
#    cat $T |  awk '{print $1" "$2/$3}' | mk_plotit_call $@ &
#    COMMENT_TEXT=':Solar*Photo'
#    cat $T |  awk '{print $1" "$2*$3}' | mk_plotit_call $@ &

# NORMAL:
    COMMENT_TEXT=':SolarPanel*PhotoCell'
    cat $T > foo
    cat $T | awk '{print $1" "$2*$3":"$4}' | mk_plotit_call $@
    #cat $T | awk '{print $1" "$2":"$2*$3}' | mk_plotit_call $@
#
#else
#    die "Dataset has $datapts data points! Don't know how to deal with this"
fi

exit 0

