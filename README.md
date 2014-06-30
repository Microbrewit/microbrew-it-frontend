Microbrew.it Frontend
====================

This repository contains the web frontend for Microbrew.it.

## The Application
The Microbrew.it frontend is an Angular.js application that acts as a GUI for the Microbrew.it API.

## Installation
You need Node.js and NPM installled globally on your system.

Open a terminal instance and navigate to the cloned microbrew-it.frontend directory and run the following commands:

- ```npm install -g bower grunt-cli```

- ```cp microbrew-it.json-dist microbrew-it.json```

- ```npm install``` (installs local npm dependencies, mostly grunt tasks)

- ```bower install``` (gets frontend dependencies like for isntance Angular)

- ```grunt``` (runs the build process, starts a node instance, and starts a watcher)

Microbrew.it should now build, and a node instance serving the frontend should be started at http://localhost:3000.
