#!/usr/bin/env bash
#set -x
set -e
set -u
set -o pipefail
set -o noclobber
#set -f # no globbing
#shopt -s failglob # fail if glob doesn't expand

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "${DIR}/.env"
if [ -f "$DIR/.env-local" ]; then
	source "$DIR/.env-local"
fi

for d in $(find "$(cd ${DIR}/../loaders; pwd)" -mindepth 1 -maxdepth 1 -type d | sort); do
		
	if [[  $d == *.off ]]; then
		echo skipping loader: $d
		continue
	fi
	
	echo loading: $d
	
	if [ -f "${d}/load.sh" ]; then
		"${d}/load.sh"
	fi
done

