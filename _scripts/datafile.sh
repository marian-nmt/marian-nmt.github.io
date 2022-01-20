#!/usr/bin/env bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <VERSION_FILE> <SHA_FILE> <OUTPUT_FILE>"
    exit 3
fi

# Inputs
version_file=$1
sha_file=$2
output=$3

# Process
version_full=$(cat ${version_file})
version=$(awk '{print substr($1,2)}' <<< ${version_full})

# Output
cat <<EOF > ${output}
version: ${version}
version_full: ${version_full}
sha: $(cat ${sha_file})
EOF
