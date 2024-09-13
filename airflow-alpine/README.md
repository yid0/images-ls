# Airflowpine

This Docker image contains Apache Airflow installed on Alpine Linux.

### Quickstart

        docker run --name airflowpine -d -p 8080:8080 yidoughi/airflowpine:latest
        
        docker exec -it airflowpine sh -c "airflow -h && airflow webserver" 

## Build 

        docker buildx build --build-arg ARG_1 --build-arg ARG_2 -t yidoughi/airflowpine:latest .

## Supported Args

| Arg name  | Description          | Default value |
| :--------------- |:---------------:| -----------------:|
| ALPINE_VERSION  |   Version of alpine linux wanted to use |  3.20 |
| AIRFLOW_HOME | Path of Airflow home folder | /usr/local/airflow |
| AIRFLOW_VERSION     | Airflow version to install |    2.10.1 |
| VIRTUAL_ENV | path of the python virtual env (based on WORKDIR_APP)| NA     |
| USERNAME | Admin username  to access adminstration panel | admin |
| PASSWORD | Password for the Admin user | admin |
| EMAIL |Email of the Admin user | admin@admin .com |

## Supprted version with ```latest``` tag

                Alpine: 3.20
                Python 3.12.5 
                Airflow: 2.10.1

## TODO 
- Remove sensitive data for prodcution mode                
