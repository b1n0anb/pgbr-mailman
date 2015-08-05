Mailman server of PostgreSQL Brasil User Group

## How to run 

The environment of PostgreSQL Brasil User Group has a reverse proxy for Apache HTTPD and Postfix is expose directly in server hosted. 

### Building 

```
$git clone git@github.com:fike/pgbr-mailman.git pgbr-mailman

```
Before to build the pgbr-mailman container, you need create the Opendkim hash.

```
$cd pgbr-mailman

$docker build -t pgbr-mailman .
```

### Running 

```
$docker run -d -p 0.0.0.0:25:25 -p 127.0.0.1:8084:80  
   -v /data/mailman:/var/lib/mailman 
   -v /data/postgresql.org.br:/srv/postgresql.org.br 
   -v /date/ssl:/etc/ssl 
   -h olifante.postgresql.org.br 
   --privileged=true mailman
```

### Known Issues

1. Encoding broke in the mailman site. 

- https://listas.postgresql.org.br/cgi-bin/mailman/listinfo

2. logrotate runs and it's stopping mailman process.

  If you found other problems, please, report in Issues on Github.
