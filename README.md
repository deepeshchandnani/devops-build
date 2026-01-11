📌 Project Overview

Is project me ek pre-built React application ko production-ready DevOps pipeline ke through deploy kiya gaya hai.

🔥 Key Highlights

React app served via Nginx (no npm build in container)

Dockerized application

CI using Jenkins

Image registry: Docker Hub (Dev & Prod repos)

Deployment on AWS EC2

Open-source Monitoring using Uptime Kuma

Email / Telegram alert on application DOWN

🏗️ Architecture Overview

Developer
   |
   |  (git push)
   v
GitHub (dev / master)
   |
   |  Webhook
   v
Jenkins (CI)
   |
   |  docker build & push
   v
Docker Hub
   |
   |  docker pull
   v
AWS EC2 (Docker + Nginx)
   |
   |  HTTP (80)
   v
Users / Browser


📁 Repository Structure

devops-build/
│
├── build/                  # Pre-built React files
││   ├── index.html
││   └── static/
│
├── nginx.conf               # Custom Nginx config
├── Dockerfile               # Nginx-based Docker image
├── docker-compose.yml       # Container orchestration
│
├── build.sh                 # Build & push Docker image
├── deploy.sh                # Deploy image on server
│
├── Jenkinsfile              # Jenkins CI pipeline
│
├── .dockerignore
├── .gitignore
│
└── README.md                # Project documentation

🧰 Tech Stack Used

Category             	Tool
Frontend        	React (pre-built)
Web Server	          Nginx
Containerization	    Docker
CI/CD               	Jenkins
Registry	           Docker Hub
Cloud                	AWS EC2
Monitoring	      Uptime Kuma (Open-Source)

STEP 1: Clone the Repository
git clone https://github.com/<your-username>/devops-build.git
cd devops-build

🧱 STEP 2: Nginx Configuration (Port 80)

nginx.conf file React SPA ko serve karta hai:

server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri /index.html;
    }
}

🔍 Why this is needed?

React is a SPA (Single Page App)


🐳 STEP 3: Dockerfile (Nginx Based – No NPM)
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY build/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

🔑 Important Points

❌ No npm install

❌ No npm run build

✅ Directly React ke build files serve ho rahi hain

🧩 STEP 4: docker-compose.yml
version: "3.8"

services:
  react-app:
    image: deepesh79/dev:latest
    container_name: react-app
    ports:
      - "80:80"
    restart: always

🧪 STEP 5: Bash Scripts
🔹 build.sh
#!/bin/bash

IMAGE_NAME="deepesh79/dev"
TAG="latest"

docker build -t $IMAGE_NAME:$TAG .
docker push $IMAGE_NAME:$TAG

🔹 deploy.sh
#!/bin/bash

docker pull deepesh79/dev:latest

docker stop react-app || true
docker rm react-app || true

docker run -d \
  --name react-app \
  -p 80:80 \
  --restart always \
  deepesh79/dev:latest


Make executable:

chmod +x build.sh deploy.sh

🚫 STEP 6: .dockerignore & .gitignore
.dockerignore
.git
node_modules
README.md

.gitignore
node_modules
.env

🌿 STEP 7: Git Workflow (CLI Only)
git checkout -b dev
git add .
git commit -m "Initial DevOps setup"
git push origin dev


dev branch → Dev Docker Hub repo

master branch → Prod Docker Hub repo

🐳 STEP 8: Docker Hub Setup
Repositories
Repo	Visibility
deepesh79/dev	Public
deepesh79/prod	Private

Login:

docker login

🤖 STEP 9: Jenkins Setup (CI)
Jenkins Pipeline Logic

dev branch → build & push dev image

master branch → build & push prod image

Jenkinsfile (CI only)
pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = 'dockerhub-creds'
        DEV_IMAGE = 'deepesh79/dev:latest'
        PROD_IMAGE = 'deepesh79/prod:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push DEV') {
            when { branch 'dev' }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDS) {
                        sh 'docker build -t $DEV_IMAGE .'
                        sh 'docker push $DEV_IMAGE'
                    }
                }
            }
        }

        stage('Build & Push PROD') {
            when { branch 'master' }
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDS) {
                        sh 'docker build -t $PROD_IMAGE .'
                        sh 'docker push $PROD_IMAGE'
                    }
                }
            }
        }
    }
}

☁️ STEP 10: AWS EC2 Setup
Instance Details

AMI: Ubuntu 22.04

Type: t2.micro

Port:

22 → SSH (My IP)

80 → HTTP (Public)

Deployment
docker pull deepesh79/dev:latest
docker run -d -p 80:80 deepesh79/dev:latest


Access:

http://<EC2_PUBLIC_IP>

📊 STEP 11: Monitoring (Open-Source)
Tool Used: Uptime Kuma

Run container:

docker run -d \
  --name uptime-kuma \
  -p 3001:3001 \
  -v uptime-kuma:/app/data \
  --restart always \
  louislam/uptime-kuma


Access UI:

http://<EC2_PUBLIC_IP>:3001

Monitor Setup

Type: HTTP

URL: http://<EC2_PUBLIC_IP>

Interval: 60s

Notification

Email (SMTP) / Telegram

Alerts sent only when app goes DOWN

🧪 Monitoring Test
docker stop react-app
# Alert received

docker start react-app
# Recovery alert received


