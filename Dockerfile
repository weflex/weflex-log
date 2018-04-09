FROM sebp/elk:620

# overwrite beats input config file
ADD conf/02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf

# overwrite elasticsearch output config file
ADD conf/30-output.conf /etc/logstash/conf.d/30-output.conf
