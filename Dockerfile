FROM node:alpine
# This specifies "Base Image" for e.g. with this line, we ll get the basic dependencies needed to run a node application
# Base Image is different for different applications for e.g. it is different for Python apps
# After : you specify the node version. With "alpine", we get the minimum dependencies needed to run our node apps

WORKDIR /app
# This line specifies where to put all the files and folders from our root working directory
# Think of "Docker Image" is like a box which will contain all the files and folders and dependencies
# So, in DockerImage box, a new folder will be created with the name "app" where all the content will be copied

COPY package.json .
# First copy the package.json file to DockerImage box
# By putting this command here, you can avoid running "RUN npm install" everytime your code changes.
# "RUN npm install" instruction will only run if package.json file has changed otherwise it uses cached version.
# This saves us time as "RUN npm install" takes the most time

RUN npm install
# This command installs the dependencies in package.json into DockerImage box
# What happens is when this line is reached, an intermediate container is run and that actually installs all the 
# dependencies and once it is done, it disposes of that intermediate container and copies the node_modules folder into DockerImage box

COPY . .
# This line actually copying the files and folders from root directory to DockerImage box
# Normally, the root working directoy is where Dockerfile lies
# First dot specifies the root directory of our project and the second dot specifies the root path of DockerImage box

CMD ["npm", "run", "start"]
# To run our app inside of the container that is built off of the Docker Image
# This will also be part of DockerImage box
# Whenever Docker Image spins up a container, it is going to run this command which will allow the container to run our app