FROM python:3.7.9

# Install locust
RUN pip install pyzmq locust faker

ADD locustfile.py /config/locustfile.py
ADD runLocust.sh /usr/local/bin/runLocust.sh

ENV LOCUST_FILE /config/locustfile.py

EXPOSE 8089

ENTRYPOINT ["bash","/usr/local/bin/runLocust.sh"]
