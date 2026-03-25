FROM jenkins/jenkins:lts

USER root
RUN apt-get update && apt-get install -y docker.io python3 python3-pip git && rm -rf /var/lib/apt/lists/*

# กลับไป Jenkins user
USER jenkins

# สร้าง workspace
RUN mkdir -p /var/jenkins_home/workspace/flask-docker-app
WORKDIR /var/jenkins_home/workspace/flask-docker-app

# copy project
COPY requirements.txt . 
COPY . .

# สร้าง virtualenv และติดตั้ง dependencies
RUN python3 -m venv /var/jenkins_home/venv
ENV PATH="/var/jenkins_home/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# expose ports
EXPOSE 8080 50000 5000

# start Jenkins
CMD ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]