# DevOps

## travis-ci auto-build and deploy

[![Build Status](https://travis-ci.org/sofwerx/synthetic-target-area-of-interest)](https://travis-ci.org/sofwerx/synthetic-target-area-of-interest)

The `.travis.yml` in this project runs the `build.sh` script to do a `docker-compose` to a ppc64le docker host with GPUs.

The `.dm.enc` file in this project is a travis encrypted version of the `.dm` file:

    travis login --org --auto
    travis encrypt-file .dm --add

The `.dm` file was created from a `dmport` export of the `docker-machine` for ppc64le host:

    dmport --export {machine} > .dm

The `docker-machine` was created using the "generic" driver while in the [swx-devops](https://github.com/sofwerx/swx-devops) project, and is also stored in trousseau.

    docker-machine create -d generic --generic-ip-address 1.2.3.4 --generic-ssh-key ${devops}/secrets/ssh/sofwerx --generic-ssh-user docker --engine-storage-driver overlay2 swx-gpu

If you already have a /var/lib/docker tree full of aufs, it's probably best to use aufs instead of overlay2 above, otherwise you will want to do a `docker save` and export images to a docker registry before hand, or you'll lose all of your images and containers.

The only things of note:

- before I did that `docker-machine` command, I had to create a `docker` user on that host that had a `NOPASSWD: ALL` in the /etc/sudoers file.

- the docker-machine command errored out with a message:

    docker daemon` is not supported on Linux. Please run `dockerd` directly

To fix that, I had to manually update the systemd `docker.service` to run `dockerd` instead of `docker daemon`:

    sed -e 's/docker daemon/dockerd/' -i /etc/systemd/system/docker.service.d/10-machine.conf
    systemctl daemon-reload
    systemctl restart docker.service

