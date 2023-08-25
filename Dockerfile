FROM python:3.11.4-alpine

WORKDIR /data
COPY . /data


RUN apk add tzdata nodejs npm cargo libffi-dev openssl-dev nmap tzdata
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

ENV TZ UTC
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /data/app/static

RUN npm install
RUN npm run build

WORKDIR /data

EXPOSE 5690
CMD [ "gunicorn", "--worker-class", "geventwebsocket.gunicorn.workers.GeventWebSocketWorker", "--bind", "0.0.0.0:5690", "-m", "007", "run:app" ]
