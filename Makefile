run:
	bash run_docker_neo4j.sh

stop:
	docker stop neo4j

reset:
	rm -rf data/
	mkdir data/

