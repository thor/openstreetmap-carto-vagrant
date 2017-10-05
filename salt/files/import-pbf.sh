#!/bin/bash
set -euo pipefail
IFS=$'\n\t' 

PROGNAME=$(basename $0)
IMPORTMODE="--append"
IMPORTFILE=

if [ $# -eq 0 ]; then
	echo "Usage: $PROGNAME [--create] FILE"
	exit 1
fi


function error
{
	echo "${PROGNAME}[${2:-"??"}]: ${1:-"Unknown Error"}" 1>&2
	exit ${3:-1}
}

for arg in "$@"
do
	case "$arg" in
		"--create")
			IMPORTMODE="--create"
			;;
		"--"*)
			error "Unrecognized argument '$arg'!"
			break 2
			;;
		*)
			IMPORTFILE=$arg
			;;
	esac
done
if [ "$IMPORTFILE" ]; then
	if [ -r "$IMPORTFILE" ]; then

		trap 'error "osm2pgsql could not import $IMPORTFILE" $LINENO $?' ERR
		sudo -u postgres osm2pgsql $IMPORTMODE  \
			--cache 1536 --number-processes 4 --hstore \
			--style /srv/openstreetmap-carto/openstreetmap-carto.style --multi-geometry \
			"$IMPORTFILE"
		touch "$IMPORTFILE".imported
		# Stateful ending to let Salt know
		echo '' # required
		echo "changed=yes comment='$IMPORTFILE imported into GIS-database'"
	else
		error "File '$IMPORTFILE' could not be found!" ${LINENO} 2
	fi
else
	error "File to import was not specified!" ${LINENO}
fi

# Script for near-end provisioning of dev. environment.
# Used for importing an extract of OSM data into the gis database.
# TODO: Further abstractify the processes.
