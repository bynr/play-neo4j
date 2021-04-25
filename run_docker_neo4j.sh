#!/bin/sh

# start a neo4j docker container with apoc and bloom (server variant) configured
# this requires to have
# * curl, unzip and jq being installed
# * having a valid bloom license file

# released under the WTFPL (http://www.wtfpl.net/)
# (c) Stefan Armbruster

NEO4J_VERSION=3.5.7
APOC_VERSIONS_JSON=https://raw.githubusercontent.com/neo4j-contrib/neo4j-apoc-procedures/master/versions.json
NEO4J_PASSWORD=123

[ -d plugins ] || mkdir plugins
[ -d plugins ] || mkdir data

cd plugins

# download apoc if not yet there.
# note: we need to follow redirects and want to use orig filename
# gotcha: if you have a non-matching version of apoc, this will *not* fail.
if ! ls apoc-*-all.jar 1> /dev/null 2>&1; then
	# resolve correct apoc version
	APOC_URL=`curl -s $APOC_VERSIONS_JSON | jq -r ".[] | select (.neo4j == \"$NEO4J_VERSION\") | [.jar] | first"`
	#echo $APOC_URL
	curl -L -C - -O -J "$APOC_URL"
fi

cd ..

docker run \
--rm \
-e NEO4J_AUTH=neo4j/${NEO4J_PASSWORD} \
-e NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
-e NEO4J_apoc_import_file_enabled=true \
-e NEO4J_dbms_security_procedures_unrestricted=apoc.\\\* \
-v "$PWD/plugins":/plugins \
-p 7474:7474 \
-p 7687:7687 \
-v "$PWD/data":/data \
-v "$PWD/import":/var/lib/neo4j/import \
--user=$(id -u):$(id -g) \
--name=neo4j \
neo4j:${NEO4J_VERSION}-enterprise
