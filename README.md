# Docker Guide for Beginners

This is a guide for beginners who have zero knowledge of Docker. It contains all the important terminologies and concepts that you need to know to have the basic understanding of Docker.

## Docker
- ***A Tool*** for creating and managing containers
- You can create containers without Docker but it is the defacto standard for creating and managing containers as it makes the whole process easy
- These are the three main types of cloud computing: PaaS, SaaS, IaaS. ***Docker is a set of PaaS products***

## Container
- It is a completely isolated environment 
- Code + All its dependencies to run that code
- For e.g. NodeJS Code + Packages to run NodeJS code + NodeJS Runtime 
- Containers work standalone. They have everything to run the containing code
- All modern OS support containers

## Why do we need containers?
1. Multiple people work on the same projects and they might have different OS and different packages like NodeJS versions installed so the NodeJS app might fail on some developer’s machines if there is inconsistency
	- For e.g. Our Node app requires Node v14 and Linux OS but DevA has Node v13 installed on his computer and DevB has Windows OS
	- If we use a container, the container will have its own OS and Node version
2. Development and Production environments may have different OS and NodeJS versions so our code might work locally on dev but fail in the production environment
	- If we use Docker image and spin up a container from it at both dev and prod, then we won’t have to deal with any OS or versioning mismatch issue

## Docker Desktop
- It is a GUI application to manage (run, stop, kill, remove) Docker Images and Containers
- You cannot run any docker commands in Terminal if Docker Desktop is not running
- It is only available on macOS and Windows ***if the requirements are met***

## Docker Toolbox
- An alternative tool to Docker Desktop means if you cannot run Docker Desktop on your macOS and Windows
- On older OS, containers are not supported so you cannot install Docker Desktop
- So, what you do is first install a Linux Virtual Machine on your old macOS or Windows and then install Docker Toolbox in that VM to run Docker
- You cannot run any docker commands in Terminal if Docker Toolbox is not running
- It is only available on macOS and Windows ***if the requirements are NOT met***

## Docker Engine
- No matter we install **Docker Desktop** or **Docker Toolbox**, we actually install Docker Engine
- Linux natively supports containers and the technology Docker uses so you can directly install Docker Engine on Linux
- Unlike macOS and Windows, where you have to run Docker Desktop or Docker Toolbox first to run any docker commands, on Linux you can run any commands without explicitly running anything

## Docker Hub
It is a website and central repository just like GitHub but it contains different Docker Images

## Dockerfile
***A file*** that contains a bunch of instructions needed to generate/build a docker image

## Docker Image
- Docker image contains everything needed to run our application
- Docker Image is read-only. It is ***not the running application*** itself
- Docker image allows us to spin up as many running instances of the application

## Docker Container
- When we want to run our NodeJS app, we create an instance of the Docker Image
- It is basically the ***running instance of our application***

## .dockerignore file
- We specify the files and folders we don’t want to be copied from our root project working directory to the DockerImage box
- We can keep “node_modules” in this file because we already have the “RUN npm install” command in the Dockerfile

## Port Mapping
- Let’s say your node app runs on localhost:3000 and now you write a Dockerfile, build the image, run the container and go to the browser and enter localhost:3000.
- Your application won’t run because the browser points to your machine’s port, not the container’s port
- So, you have to do the port mapping to run the app from the container
	`$ docker run -p 3000:3000 <<ImageName>>`

- Now the port 3000 from our local machine will be forwarded to the container

## Steps to Dockerise an Application
**1. Write a Dockerfile**

![alt text](/assets/docker-file.png "Dockerfile")

![alt text](/assets/docker-image-box.png "DockerImage Box")


**2. Build a Docker Image**

- Run the above command in the root directory (. specifies the location of Dockerfile)
`$ docker build .`

- We can give the docker image a name with the -t flag
`$ docker build -t express-app .`

**3. Run an instance of Docker Image known as a Container**

`$ docker run <<imageName>>`

- Running Container commands may vary for different types of apps for e.g.
	`$ docker run <<imageName>>` (to run Node app container)

	`$ docker run -it <<imageName>>` (to run the container in interactive mode)

## Volumes
- Normally when you are running the app through a container, and if you make changes in the code, the changes won’t be shown in the running app like they usually do when you run the code directly through the `$ npm run start` command
- For the changes to show, you have to rebuild the image and run the container again. And this is a long process
- We can solve the above problem with ***Volumes***
- With Volumes, we basically map our code directory to the working directory of the container as shown in the diagram below

![alt text](/assets/volumes.png "Volumes")

- We can achieve the above mapping using the below command
	`$ -v <<absolutePath of our code>>:<<Path to the container working directory>>`

	`$ -v /Users/aqarain/Projects/test:/app`

	`$ -v $(pwd):/app` (can only be used on macOS)

- **So the final commands will be:**

	`$ docker run -v $(pwd):/app -v /app/node_modules  --name react-container -it -p 3000:3000 react-app`

	- `-v $(pwd):/app` is actually mapping Our App to the Container
	- `-v /app/node_modules` ensures that node_modules in our container are not replaced because may be Our App doesn’t have node_modules installed and if don’t add this flag then the node_modules folder in our Container will also be removed as it will be replaced
	- `--name react-container` is the name of the container 
	- `-it`  is used to run react app container
	- `-p 3000:3000` is doing the port mapping
	- `react-app` is the Docker Image name

## Docker Compose
- Used to manage multi-container applications
- Let’s say, for your front-end app to run, you have to run a back-end app as well. Now for this whole process what you have to do is:
	- Build docker image for the front-end app
	- Run the container using a complex command which involves different tags as shown in the Docker Volumes
	- Build docker image for the back-end app
	- Again run the container for the back-end app using a complex command which involves different tags as shown in the Docker Volumes
- Here there are only two interdependent apps and still as you see this is a cumbersome process as you might make a mistake running the different commands. Imagine if an app is dependent on 10 different apps and you have to repeat the same steps for each.
- This is where docker compose comes into the picture
- With ***docker compose***, we can put all of the configurations into one file (***docker-compose.yaml***) like how to build the image and how to run the container
- We can put configurations for multiple docker images and containers that are needed to run our app into 1 file (***docker-compose.yaml***) and later on, execute that file with one simple command: `$ docker-compose up`
- This will automatically create all the docker images and run the required containers
- To stop the containers: `$ docker-compose down`

## Docker Commands
|  Purpose |  Commands |
| ------------ | ------------ |
| **Build Docker Image**  |  `$ docker build .`<br> `$ docker build -t express-app . `(***-t*** specifies image name) <br> `$ docker build -t express-app:v2 .` (specifying version #) |
| **List all Images**  | `$ docker images`  |
| **Remove an Image**   | `$ docker image rm express-app:v2`  |
|  **Run Container** |  `$ docker run <<imageName>>` <br> `$ docker run express-app` <br> `$ docker run --name express-container express-app` (***--name*** gives a name to the container) |
|  **Run Container detached from the Terminal** |  `$ docker run -d  express-app` |
|  **List all running Containers** |  `$ docker ps` |
|  **Stop a Container** | `$ docker stop <<containerId / name>>` <br> `$ docker kill <<containerId / name>>` <br> <br> Both commands shut down the container but with ***stop***, the cleanup process is performed first and then the container is shut down|
|  **Start a Container** |  `$ docker start <<containerId / name>>` <br><br> It starts the container that you stopped or killed but not removed |
| **Remove a Container**  |  `$ docker rm <<containerName>>` <br><br> You cannot remove a running container, you first have to kill/stop it |
