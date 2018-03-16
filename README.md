# secret-helper

## Build and Run container

> docker build -t secret-helper .

> docker run --name='secret-helper' --net=host -d secret-helper

## Login to container and setup settings file

> docker exec -it secret-helper bash

> cp settings.yml.example settings.yml

> vim settings.yml
