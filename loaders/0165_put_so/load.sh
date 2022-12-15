#!/usr/bin/env bash
#
# load.sh for Sequence Ontology CodeSystem, into server at $HAPI_R4
#   reads:  so_CodeSystem.json

set -euo pipefail

# See http://stackoverflow.com/questions/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "${DIR}/../../bin/env.sh"
if [ -f "${DIR}/../../bin/.env-local" ]; then
	source "${DIR}/../../bin/.env-local"
fi

FILE="so_CodeSystem.json"
ID
	
if [ -f "${FILE}.loaded.txt" ] || [ -f "${FILE}.loading.txt" ] ; then
	echo Already loaded/loading: $FILE
	continue
fi
	
echo loading: $FILE
	
	if curl -v -X PUT --header "Content-Type: application/fhir+json" \
		--header "Prefer: return=OperationOutcome" \
		--output "${FILE}.response.txt" \
		-T "$FILE" \
		"${HAPI_R4}/CodeSystem/$ID" > "${FILE}.loading.txt" 2>&1; then
		
		mv "${FILE}.loading.txt" "${FILE}.loaded.txt"
	fi

done
