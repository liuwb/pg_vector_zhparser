# pg_vector_zhparser
Dockerfile for PostgreSQL with vector and zhparser extensions

## Build Image
```bash
docker build --rm -t pg_vector_zhparser:1.0 -f ./Dockerfile .
```

## Run Container
```bash
docker run -d --name pg_vector_zhparser -p 5432:5432 --ipc=host \
    -v ${YOUR_DATA_DIR}:/var/lib/postgresql/data \
    -v ${YOUR_CONFIG_FILE}:/etc/postgresql/postgresql.conf \
    -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=${YOUR_SUPERUSER_PASS} \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    pg_vector_zhparser:1.0
```
