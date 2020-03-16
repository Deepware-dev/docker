# Dockerfiles to build Deepware Images

## Setup docker

To install and setup docker you can run the script:

<pre><code>./setup_docker.sh</code></pre>

To run docker you can run the following script:

<pre><code>./run.sh deepwaredev/deep-image </code></pre>

and than, in the docker, run:

<pre><code>terminator </code></pre>

now, you can run, roscore, rviz ecc...

if you want to mount your home folder, start the docker with the following option:

<pre><code>/run.sh -v /home/$USER:/home/deepware deepwaredev/deep-image </code></pre>

now you can find your home folder on home deepware.
