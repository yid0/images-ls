# Fastpine 

Run a FastAPI application in few seconds with a lightweight Python [pythopine](../python-alpine/README.md) image based on Alpine Linux.

### Quickstart

        docker run --name fastpine -d -p 8000:8000 yidoughi/fastpine:latest
        
        docker exec -it fastpine sh -c "fastapi run status.py"

with workers flag :

         docker exec -it fastpine sh -c "fastapi run status.py --workers 4"

  ### Check status : 
  
                curl http://localhost:8000/status 

You might to get somthing like this :


                        *   Trying 127.0.0.1:8000...
                * TCP_NODELAY set
                * Connected to localhost (127.0.0.1) port 8000 (#0)
                > GET /status HTTP/1.1
                > Host: localhost:8000
                > User-Agent: curl/7.68.0
                > Accept: */*
                >
                * Mark bundle as not supporting multiuse
                < HTTP/1.1 200 OK
                < date: Wed, 11 Sep 2024 13:08:43 GMT
                < server: uvicorn
                < content-length: 8
                < content-type: application/json
                <
                * Connection #0 to host localhost left intact   

## How to build your own image 

        git clone https://github.com/yid0/images-ls.git && cd ./images-ls/fastapi-alpine

        docker buildx build -t yidoughi/fastpine:latest .      

## Build with Args

        docker build --build-arg ALPINE_VERSION=3.19 --build-arg FASTAPI_VERSION=0.112.0 --build-arg WORKDIR_APP=app -t yidoughi/fastpine:latest .

OR

        docker buildx build --build-arg ALPINE_VERSION=3.19 --build-arg FASTAPI_VERSION=0.112.0 --build-arg WORKDIR_APP=app -t yidoughi/fastpine:latest .


### Supported Args :

| Arg name  | Description          | Default value |
| :--------------- |:---------------:| -----------------:|
| ALPINE_VERSION  | Version of alpine linux to use |  3.20 or latest |
| FASTAPI_VERSION | FastAPI version to install | 0.112.1 
| WORKDIR_APP     | Folder containing fastapi application |   app |
