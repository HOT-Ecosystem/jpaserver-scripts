#!/usr/bin/env bash
set -euo pipefail

# Super basic download and convert MONDO to FHIR for load
# Names the output file in accordance with want the load.sh
#  script expects.
# TODO: Possibly get from: https://github.com/joeflack4/mondo-on-fhir/releases/download/latest/mondo-minified.fhir.json

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

# get fhir-owl to convert
if [[ !  -f $DIR/../../lib/fhir-owl-1.1.0.jar ]] ; then
    wget https://github.com/HOT-Ecosystem/fhir-owl/releases/download/Oct_24_2022/fhir-owl-1.1.0.jar
    mv fhir-owl-1.1.0.jar $DIR/../../lib
fi


# get mondo
if [[ !  -f mondo.owl ]] ; then
    wget http://purl.obolibrary.org/obo/mondo.owl
fi

# includes bits of CHEBI etc, file is about 2x in size.
java -jar $DIR/../../lib/fhir-owl-1.1.0.jar \
    -i mondo.owl \
    -o $DIR/CodeSystem-mondo.json \
    -id mondo \
    -name "MondoDiseaseOntology" \
    -mainNs http://purl.obolibrary.org/obo/MD_  \
    -status active \
    -codeReplace "_,:" \
    -s http://www.geneontology.org/formats/oboInOwl#hasExactSynonym \
  -t "Mondo Disease Ontology" \
  -content complete \
  -descriptionProp http://purl.org/dc/elements/1.1/subject \
  -useFhirExtension \
  -dateRegex "(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})" 

