JAVA_VERSION ?= 21
ALPINE_VERSION ?= 3.20
FASTAPI_VERSION ?= 0.112.1
AIRFLOW_VERSION ?= 2.10.1
KEYCLOAK_VERSION ?= 25.0.6
POSTGRES_VERSION ?= 16.0
CONTAINER= pythopine
COMMAND ?= sh
TAG ?= latest
ENV ?= production
OPTIONS ?=

.PHONY:	build-pythopine
build-pythopine:
			docker buildx build -f ./pyhton-alpine/Dockerfile -t yidoughi/pythopine:latest --progress=plain

.PHONY:	build-fastpine
build-fastpine:
			docker buildx build -f ./fastapi-alpine/Dockerfile  --build-arg FASTAPI_VERSION=${FASTAPI_VERSION} -t yidoughi/fastpine-${FASTAPI_VERSION}:${ALPINE_VERSION} ./fastapi-alpine ${OPTIONS}  --progress=plain
			docker tag yidoughi/fastpine-${FASTAPI_VERSION}:${ALPINE_VERSION} yidoughi/fastpine-${FASTAPI_VERSION}:latest 
			docker tag yidoughi/fastpine-${FASTAPI_VERSION}:latest yidoughi/fastpine:latest

.PHONY:	run-fastpine
run-fastpine:
		docker rm -f fastpine && \
		docker run --rm --name fastpine -p 8000:8000 -d yidoughi/fastpine:latest

.PHONY:	build-javapine
build-javapine:
		docker buildx build --build-arg "ALPINE_VERSION=${ALPINE_VERSION}" --build-arg "JAVA_VERSION=${JAVA_VERSION}" -t yidoughi/javapine-${JAVA_VERSION}:${ALPINE_VERSION} -t yidoughi/javapine-${JAVA_VERSION}:latest ./java-alpine --progress=plain

.PHONY:	run-javapine
run-javapine:
		docker rm -f javapine && \
		docker run --rm --name javapine -d yidoughi/javapine-${JAVA_VERSION}:${ALPINE_VERSION}

.PHONY:	build-javapine-slim
build-javapine-slim:
		docker buildx build -f ./java-alpine/Dockerfile.slim  --build-arg "ALPINE_VERSION=${ALPINE_VERSION}" --build-arg "JAVA_VERSION=${JAVA_VERSION}" -t yidoughi/javapine-slim:${JAVA_VERSION}-${ALPINE_VERSION} ./java-alpine --progress=plain

.PHONY:	run-javapine-slim
run-javapine-slim:
		docker rm -f javapine-slim && \
		docker run --rm --name javapine-slim -d yidoughi/javapine-slim:${JAVA_VERSION}-${ALPINE_VERSION} ${OPTIONS}

.PHONY:	push-javapine-slim
push-javapine-slim:
		docker push docker.io/yidoughi/javapine-slim:${TAG}

.PHONY:	build-rubypine
build-rubypine:
		docker buildx build --build-arg "ALPINE_VERSION=${ALPINE_VERSION}" -t yidoughi/rubypine:${ALPINE_VERSION} ./ruby-alpine --progress=plain
		docker tag yidoughi/rubypine:${ALPINE_VERSION} yidoughi/rubypine:latest

.PHONY:	run-rubypine
run-rubypine:
		docker rm -f rubypine && \
		docker run --rm --name rubypine -d yidoughi/rubypine:latest ${OPTIONS}

.PHONY:	push-rubypine
push-rubypine:
		docker push docker.io/yidoughi/rubypine:${TAG}

.PHONY:	build-keyclopine
build-keyclopine:
			docker buildx build --build-arg "KC_ENV=${ENV}" --build-arg "JAVA_VERSION=21" -t yidoughi/keyclopine-${KEYCLOAK_VERSION}:${JAVA_VERSION} ./keycloak-alpine --progress=plain  ${OPTIONS}

.PHONY:	push-keyclopine
push-keyclopine:
		docker push docker.io/yidoughi/keyclopine-${KEYCLOAK_VERSION}:${JAVA_VERSION}

.PHONY:	build-postgrepine
build-postgrepine:
			docker buildx build  -t yidoughi/postgrepine-${POSTGRES_VERSION}:${ALPINE_VERSION} ./postgres-alpine --progress=plain ${OPTIONS}
			docker buildx build  -t yidoughi/postgrepine-${POSTGRES_VERSION}:latest ./postgres-alpine --progress=plain
			docker buildx build  -t yidoughi/postgrepine:latest ./postgres-alpine --progress=plain

.PHONY:	run-postgrepine
run-postgrepine:
		docker rm -f postgrepine && \
		docker run --rm --name postgrepine -d -p 5432:5432 yidoughi/postgrepine:latest

.PHONY:	push-postgrepine
push-postgrepine:
		docker push docker.io/yidoughi/postgrepine-${POSTGRES_VERSION}:${TAG}
		docker push docker.io/yidoughi/postgrepine:${TAG}

.PHONY:	build-opensalpine
build-opensalpine:
		docker buildx build  -t yidoughi/opensalpine:latest ./opensearch-alpine --progress=plain 
		
.PHONY:	build-airflowpine
build-airflowpine:
		docker buildx build  --build-arg AIRFLOW_VERSION=${AIRFLOW_VERSION} -t yidoughi/airflowpine:latest ./airflow-alpine --progress=plain
		docker tag yidoughi/airflowpine:${AIRFLOW_VERSION} yidoughi/airflowpine:latest
		docker buildx build  -t yidoughi/postgrepine:latest ./postgres-alpine --progress=plain

.PHONY:	run-keyclopine
run-keyclopine:
		docker rm -f keyclopine && \
		docker run --rm --name keyclopine -e "KC_HTTPS_PORT=8843" -e "KC_DB_URL_HOST=172.19.172.190" -d -p 8843:8843 yidoughi/keyclopine-${KEYCLOAK_VERSION}:${JAVA_VERSION} 

.PHONY:	run-airflowpine
run-airflowpine:
		docker rm -f airflowpine && \
		docker run --rm --name airflowpine -d -p 8080:8080 yidoughi/airflowpine:latest

.PHONY:	run-opensalpine
run-opensalpine:
		docker rm -f opensalpine && \
		docker run --rm --name opensalpine -d -p 9200:9200 -p 9600:9600 yidoughi/opensalpine:latest

.PHONY:	exec-fastpine
exec-fastpine:
	docker exec -it fastpine sh	

.PHONY:	exec-javapine-slim
exec-javapine-slim:
	docker exec -it javapine-slim sh

.PHONY:	rubypine
exec-rubypine:
	docker exec -it rubypine sh

.PHONY:	exec-postgrepine
exec-keyclopine:
	docker exec -it keyclopine sh

.PHONY:	exec-postgrepine
exec-postgrepine:
	docker exec -it postgrepine sh

.PHONY:	exec-airflowpine
exec-airflowpine:
	docker exec -it airflowpine sh	
