# docker-papercut-mf
PaperCut MF for Docker 

## [Papercut MF](https://www.papercut.com/products/mf/)
**[PLEASE AGREE TO PAPERCUT'S TOS BEFORE CONTINUING](https://www.papercut.com/products/ng/manual/common/topics/license.html)**

-------

## Docker Image features
- Standalone docker image with only Papercut installed, CUPS isn't installed.
- Necessary files/volumes can be mounted to ensure the right settings are used.
- PaperCut is already installed, therefore do not mount volumes over already existing files/folders that are crucial to the server operation unless you're overwriting config files.
- `papercut` account setup. Home dir=`/papercut`.
- Papercut installed to /papercut.
- `papercut` service is run as console therefore it ouputs to stdout.
- `/papercut/server/server/data/internal` - This is where the internal database is stored.
    - If mounted on host, the database initialized by the installation during image capture will be overwritten.
    - `entrypoint.sh` will automatically initialize the database in this case if `/papercut/server/server/data/internal/derby` is missing.

-------

## Run a stack on your local machine

This will launch a mysql server, phpMyAdmin and Papercut:

    docker compose up -d

## docker run example
```bash
docker run -d \
    -p 9191:9191 \
    -p 9192:9193 \
    -p 9193:9193 \
    -v /path/on/host/to/conf:/papercut/server/data/conf \
    -v /path/on/host/to/logs:/papercut/server/logs \
    -v /path/on/host/to/custom:/papercut/server/custom \
    -v /path/on/host/to/backups:/papercut/server/data/backups \
    -v /path/on/host/to/archive:/papercut/server/data/archive \
    tomcat2111/papercut-mf
```

## Environement Variables

    Variable name                                      | Default  | MySQL 
    -----------------------------------------------------------------------
    PAPERCUT_ADMIN_USERNAME                            | admin    | 
    PAPERCUT_ADMIN_PASSWORD                            | papercut |
    PAPERCUT_REPORTS_LABEL                             | Local    |
    PAPERCUT_DATABASE_TYPE                             | Internal | MySQL
    PAPERCUT_DATABASE_URL                              |          | jdbc:mysql://database/papercut?useSSL=false
    PAPERCUT_DATABASE_DRIVER                           |          | com.mysql.cj.jdbc.Driver 
    PAPERCUT_DATABASE_USERNAME                         |          |
    PAPERCUT_DATABASE_PASSWORD                         |          |  
    PAPERCUT_SERVER_CSRF_CHECK_VALIDATE_REQUEST_ORIGIN | Y        |

## Deployment

    docker build -t tomcat2111/papercut-mf --platform linux/x86_64 .
    docker tag tomcat2111/papercut-mf:latest tomcat2111/papercut-mf:[version_tag]
    docker push tomcat2111/papercut-mf:[version_tag] 
    docker push tomcat2111/papercut-mf:latest 
