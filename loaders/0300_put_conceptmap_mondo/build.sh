# Get Mondo from: https://github.com/monarch-initiative/mondo/blob/master/src/ontology/mappings/mondo.sssom.tsv
# - or pre-converted: https://github.com/joeflack4/mondo-on-fhir/releases/download/latest/mondo.sssom.fhir.json
# Get OMOP from: (TBD @Davera)

# TODO: build (I think given that the PR hasn't been merged yet, easier to download from mondo-on-fhir instead. really needs to be merged though)
#  1.a (for now) clone sssom-py and change to the fhir branch
#  1.b. (when pr merged) pip install sssom-py
#  2.a (for now) python -m sssom convert mondo.sssom.tsv --output-format fhir --output mondo.sssom.fhir.json
#  2.b. (when pr merged) sssom convert mondo.sssom.tsv --output-format fhir --output mondo.sssom.fhir.json
