# secret-helper

## Build and Run container

> docker build -t secret-helper .

> docker run --name='secret-helper' --network=host -v /path/to/settings.yml:/secret-helper/settings.yml -v /dev/shm:/dev/shm --shm-size="256m" -d secret-helper
