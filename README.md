# secret-helper

## Build and Run container

> docker build -t secret-helper .

> docker run --name='secret-helper' --net=host
-v /path/to/settings.yml:/secret-helper/settings.yml 
-d secret-helper
