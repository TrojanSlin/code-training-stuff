#!/bin/sh

ECHO='/bin/echo'

get_longest_string()
{
    awk '{print $1}' *.txt | wc -L
}

get_longest_pattern()
{
    awk '{print $2}' *.txt | wc -L
}

# $1 -- color, e.g. 'green' or 'default'
set_text_color()
{
    case "$1" in
        'green')
            $ECHO -en '\e[32m'
            ;;
        'red')
            $ECHO -en '\e[31m'
            ;;
        'default')
            $ECHO -en '\e[0m'
            ;;
        *)
            # do nothing in this case
            ;;
    esac
}

LONGEST_STRING=$(( `get_longest_string` + 2 ))
LONGEST_PATTERN=$(( `get_longest_pattern` + 2 ))

# $1 -- file with test samples
# $2 -- expected output
run_test()
{
    local file=$1
    local expected=$2
    while read -r str pat ; do
        printf >&2 'Trying  %-*s  and  %-*s  |  '   \
            $LONGEST_STRING     \'$str\'            \
            $LONGEST_PATTERN    \'$pat\'
        res="`./TextComp \'$str\' \'$pat\'`"
        printf >&2 '%-16s' "$res"
        if [ "$res" = "$expected" ] ; then
            set_text_color >&2 green
            $ECHO >&2 'TEST PASSED'
        else
            set_text_color >&2 red
            $ECHO >&2 'TEST FAILED'
        fi
        set_text_color >&2 default
    done < $file
    $ECHO >&2
}

run_test yes.txt 'Matched'
run_test no.txt 'No matches'
