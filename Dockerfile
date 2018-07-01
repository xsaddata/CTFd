FROM python:2.7-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update && \
    apk add python python-dev libffi-dev gcc make musl-dev py-pip mysql-client

RUN mkdir -p /opt/CTFd
COPY . /opt/CTFd
WORKDIR /opt/CTFd
VOLUME ["/opt/CTFd"]

RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/
RUN for d in CTFd/plugins/*; do \
      if [ -f "$d/requirements.txt" ]; then \
        pip install -r $d/requirements.txt; \
      fi; \
    done;

RUN chmod +x /opt/CTFd/docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/opt/CTFd/docker-entrypoint.sh"]
