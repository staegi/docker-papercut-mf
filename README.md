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

## docker run example
```bash
docker run -d \
    -p 9191:9191 \
    -p 9192:9193 \
    -p 9193:9193 \
    -v /path/on/host/to/database:/papercut/server/server/data/internal \
    -v /path/on/host/to/logs:/papercut/server/logs \
    -v /path/on/host/to/conf:/papercut/server/conf \
    -v /path/on/host/to/backups:/papercut/server/data/backups \
    tomcat2111/papercut-mf
```
