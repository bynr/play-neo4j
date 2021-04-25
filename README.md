# play-neo4j

Dockerized environment to experiment and play with neo4j.

## Pre-requisites ⛓️
- docker
- python
- [py2neo](https://py2neo.org/2021.0/)
- [optional] Bloom licence

## Run 🏃 

- `make run` will setup a docker container with neo4j
- interract from python
```python
from py2neo import Graph, Node, Relationship
g = Graph("http://neo4j:123@localhost:7474")
a = Node("Person", name="Alice", age=33)
b = Node("Person", name="Bob", age=44)
KNOWS = Relationship.type("KNOWS")
g.merge(KNOWS(a, b), "Person", "name")

query = "MATCH (n) RETURN ID(n) as ID, n.Key as Key"
graph.run(query).data()
```
- `make stop` to clean up
# References 📚

Setup script to run neo4j in docker comes from: [link](https://gist.github.com/sarmbruster/883e405cf8db04c9a3179d5dc9f300b3)
