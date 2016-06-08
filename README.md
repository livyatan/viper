```
____   ____.__                     
\   \ /   /|__|_____   ___________ 
 \   Y   / |  \____ \_/ __ \_  __ \
  \     /  |  |  |_> >  ___/|  | \/
   \___/   |__|   __/ \___  >__|   
              |__|        \/       
```

Zergling generator

This is meant to be run as a docker container.

To build the viper image:

    make build

and publish it to dockerhub:

    make push

to run it:

    docker run -e COUCH=http://localhost:5984 kevinjqiu/viper

and replace `http://localhost:5984` with the actual connection string of the data store (couchdb)
