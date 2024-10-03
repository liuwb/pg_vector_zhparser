ARG PG_MAJOR=16

FROM postgres:$PG_MAJOR as builder

RUN set -ex \
  && apt-get update \
  && apt-get install -y --no-install-recommends build-essential git ntp ca-certificates autoconf automake libtool m4 postgresql-server-dev-$PG_MAJOR

RUN set -ex \
  && git clone https://github.com/hightman/scws.git \
  && cd scws \
  && touch README;aclocal;autoconf;autoheader;libtoolize;automake --add-missing \
  && ./configure \
  && make install

RUN set -ex \
  && git clone https://github.com/amutu/zhparser.git \
  && cd zhparser \
  && make install

FROM pgvector/pgvector:0.7.2-pg16

COPY --from=builder /usr/lib/postgresql/${PG_MAJOR}/lib/zhparser.so /usr/lib/postgresql/${PG_MAJOR}/lib/
COPY --from=builder /usr/local/lib/libscws.* /usr/local/lib/
COPY --from=builder /usr/share/postgresql/${PG_MAJOR}/extension/zhparser* /usr/share/postgresql/${PG_MAJOR}/extension/
COPY --from=builder /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/zhparser* /usr/lib/postgresql/${PG_MAJOR}/lib/bitcode/
COPY --from=builder /usr/share/postgresql/${PG_MAJOR}/tsearch_data/*.utf8.* /usr/share/postgresql/${PG_MAJOR}/tsearch_data/