# Cronjob

This container exists to support [borgwarehouse](https://borgwarehouse.com/). As [borgwarehouse](https://borgwarehouse.com/) metion [here](https://borgwarehouse.com/docs/admin-manual/docker-installation/#scheduled-tasks) in order to update repos information in interval. Therefore it need a cronjob.

# [Supercronic](https://github.com/aptible/supercronic)

This library is used for cronjob.

# Integration

This container is integrated into docker-compose.yml file which is located at project root directory. **An envrionment variable must be set in order to make it work**, `CRONTAB_PATH` must be set to make this container work.

`CRONTAB_PATH` need to point to a directory/folder in host machine so that container can write/read crontab file. `CRONTAB_PATH` will be mapped to directory(/etc/crontab) inside container.

You are able to create a crontab file under `CRONTAB_PATH` directory with file name `crontab`. Container will detect the file by its name and read from the crontab file. Container will create a default crontab file if not detect any crontab file by its name.

# Crontab format

```
* * * * * * * curl --request POST --url {url-to-borgwarehouse-api} --header 'Authorization: Bearer {cronjob-secret-key}' > /dev/null 2>&1
```

[Here to find borgwarehouse api url](https://borgwarehouse.com/docs/admin-manual/docker-installation/#scheduled-tasks)

For authorization key go to `stack.env` file under root project directory and find `CRONJOB_KEY`

For schedule refer [here](https://github.com/aptible/supercronic/tree/master/cronexpr#implementation)

# Files

Explain files inside supercronic container.

### Dockerfile

The docker file for building container.

### run.sh

The main bash script will be ran when container is up running. 

### crontab_default

A default crontab file specifc for borgwarehouse.

