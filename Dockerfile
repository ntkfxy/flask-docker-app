FROM jenkins/jenkins:lts

USER root

# ติดตั้งแค่ Docker CLI เพื่อให้ Jenkins สั่งรัน Docker ได้
# (ส่วน Python, pip ไม่ต้องลงในนี้ เพราะใน Jenkinsfile คุณใช้ docker.image('python:3.13-slim') แยกต่างหากอยู่แล้ว)
RUN apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# ให้สิทธิ์ user jenkins รันคำสั่ง docker ได้
RUN usermod -aG docker jenkins || true

USER jenkins