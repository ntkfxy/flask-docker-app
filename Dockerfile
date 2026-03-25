# =================================================================
# Dockerfile: jenkins-with-docker-and-python
# - ใช้ Jenkins LTS เป็น base
# - ติดตั้ง Docker CLI, Python 3.13 และ dependencies
# - พร้อมรัน Flask project และ Jenkins pipeline
# =================================================================

FROM jenkins/jenkins:lts

# ใช้ root ติดตั้ง docker, python, pip
USER root

# ติดตั้ง Docker CLI, Python และ pip
RUN apt-get update && \
    apt-get install -y docker.io python3 python3-pip git && \
    rm -rf /var/lib/apt/lists/*

# เปลี่ยนกลับไป Jenkins user
USER jenkins

# สร้างโฟลเดอร์สำหรับ workspace/project
RUN mkdir -p /var/jenkins_home/workspace/flask-docker-app

# กำหนด working directory สำหรับ project
WORKDIR /var/jenkins_home/workspace/flask-docker-app

# copy project ทั้งหมดเข้า container (optional, ถ้าใช้ volume จาก host แนะนำไม่ต้อง copy)
COPY requirements.txt .
COPY . .

# ติดตั้ง dependencies Python
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# expose ports สำหรับ Jenkins และ Flask
EXPOSE 8080 50000 5000

# start Jenkins
CMD ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]