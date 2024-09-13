# Pythpine

This Docker image contains Python and pip installed on Alpine Linux.

### Quickstart

        docker run --name pythpine -d yidoughi/pythpine:latest
        
        docker exec -it pyhpine sh -c "python -V" 

## Build 

        docker buildx build --build-arg -t yidoughi/pythpine:latest .

## Supported Args :

| Arg name  | Description          | Default value |
| :--------------- |:---------------:| -----------------:|
| ALPINE_VERSION  |   Version of alpine linux wanted to use |  3.20 |
| FASTAPI_VERSION | FastAPI version wanted to install | 0.112.1 
| WORKDIR_APP     | The application folder             |   app |
| VIRTUAL_ENV | path of the python virtual env (based on WORKDIR_APP)| NA     |
