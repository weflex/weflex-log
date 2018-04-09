WeFlex Log Monitor
==================

This repository helps to collect logs from the WeFlex servers. We use an ELK stack to process the logs.

## Dependencies

> Pre-requisite: [Docker][1] must be installed on the host machine.

1. The WeflexLog Docker [image][2] is built from [sebp/elk][3] docker image. You can read the docs [here][4].
2. [Filebeat][5] is required to be installed and running on the host machine to publish logs to server. A sample config is shown below.

> While deploying the config to production server, you must copy the **public and private** ssl keys to the docker container to `/etc/pki/tls/certs/logstash-beats.crt` and `/etc/pki/tls/private/logstash-beats.key` OR any other path which must be consistent and communicated to filebeat and [logstash config][6]. To generate public and private keys, you can use [letsencrypt.org][7] service.


### Install filebeat
`yum install filebeat`

### Filebeat sample configuration
Copy the filebeat [configuration][8] to your host machine.

### Filebeat configuration explanation

The below configuration does the following:

1. It assumes that you have a log at `/Users/pbalan/Downloads/messages` on your host machine which is required to be monitored and published to logstash. See [line 28][9].
> **You must change it to point to your log you want to publish.**
2. We set the tag to the logs published from the server on [line 93][10].
3. We set the env to the logs published from the server on [line 98][11].
4. Specify kibana host at [line 123][12].
5. Enable logstash output on [line 154][13].
6. Specify logstash host on [line 157][14].
7. Specify the path to ssl certifcate authorities on [line 161][15].

### Start filebeat
`sudo /etc/init.d/filebeat start`


### Roll up the container

- Use Dockerfile

  `docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name weflexlog_elk_1 weflextech/elk `

- Use docker-compose.yml

  `docker-compose up elk`

Make sure the configuration files are up to date at `/etc/logstash/conf.d/` by opening up a shell inside the docker container

  `docker exec -it <container-name> /bin/bash`

### Publish changes to Docker image

  1. Pull the latest image.

     `docker pull weflextech/elk:latest`

  2. Roll up a container if one is not running already.

     `docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name weflexlog_elk_1 weflextech/elk /bin/bash`

  3. ADD YOUR CHANGES.

  4. Commit your changes.

     `docker commit -m <message> -a <user> weflexlog_elk_1 weflextech/elk:latest`

  5. Login to docker hub.

     `docker login`

  6. Push your changes.

     `docker push weflextech/elk`

[1]:  https://www.docker.com
[2]:  https://hub.docker.com/r/weflextech/elk
[3]:  https://hub.docker.com/r/sebp/elk/
[4]:  http://elk-docker.readthedocs.io/
[5]:  https://www.elastic.co/products/beats/filebeat
[6]:  https://github.com/weflex/weflex-log/blob/master/02-beats-input.conf#L5-L6
[7]:  https://letsencrypt.org/
[8]:  https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml
[9]:  https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml#L28
[10]: https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml#L93
[11]: https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml#L98
[12]: https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml#L123
[13]: https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml#L154
[14]: https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml#L157
[15]: https://github.com/weflex/weflex-log/blob/master/filebeat.example.yml#L161
