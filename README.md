# synthetic-target-area-of-interest

Identify and geolocate object(s) of interest using imagery and sensor data from multiple UAVs viewing a common target area, add / update corresponding feature on GIS map layer.

This repository consists of nested git repositories as submodules. After doing a git pull, be sure to regularly run:

    git submodule update --init --recursive

## Local development

The [docker-compose.yml](docker-compose.yml) is used by the above environments.

On a mac, with docker-engine installed as the default xhyve vm, you can:

    docker-compose up

Then open a browser to the orient port:

    http://localhost:9999

Open up one browser tab as an admin, and open three more browser tabs as drones, then click on the "Enable Triangulation" button.

## Environments

There are presently two deployments of this project here at Sofwerx. These are both submodule deployed through our [swx-devops](https://github.com/sofwerx/swx-devops) repo harness:

- [github.com/sofwerx/swx-devops/local/geo](https://github.com/sofwerx/swx-devops/tree/master/local/geo)
- [github.com/sofwerx/swx-devops/local/swx-gpu](https://github.com/sofwerx/swx-devops/tree/master/local/swx-gpu)

This is deployed using `docker-compose`, with the `.yml` file appropriate for each environment:

- [geo.yml](geo.yml)
- [swx-gpu.yml](swx-gpu.yml)

## Containers

The above two deploy environments run traefik servers as reverse proxies. This allows the use of https:// URLs, which bypasses browser security alerts about sharing your location.

Beyond this, there are 3 containers that comprise this solution:

- orient
- turn
- staoi

### orient

[orient](orient/) is a git submodule inclusion of the [github.com/sofwerx/orient](https://github.com/sofwerx/orient) repository.

This is a Node.js web service for the drone/admin web interface that offers a [peerjs](http://peerjs.com/) service for mutual discovery.

#### index.html

The orient default landing page that lets any browser become either a drone or an admin.

#### drone.html

The `drone.html` page streams WebRTC video and telemetry data (location/orientation/heading) directly to the admin.
This is meant to be run on android mobile devices.
When the admin tells it to with a "Update" message:
- All drones will take a snapshot of the current video stream and post it to the staoi container's ObjectLoB web service.
- Each result will be posted back to admin as an "Updated" message.

#### admin.html

The `admin.html` page enumerates the drones in a web page, along with a map plotting their location.
When "Enable Triangulate" is clicked, a periodic timestamped "Update" message is sent to all drones for them to submit photographs to the ObjectLoB web service.
When a drone posts an "Updated" message back to the admin:
- The admin waits for 3 or more drones to submit a message for any given timestamp.
- When the 3rd message for a timestamp is received, all 3 are submitted to the staoi container's TargetLoc web service.
- If there is an intersection in the result:
  - The triangulated marker on the map is updated to reflect the new location.
  - The new location is posted to the demonstration android ATAK device to show that integration.

For more information on orient, see the [orient/README.md](https://github.com/sofwerx/orient/blob/master/README.md)

### turn

This is a TURN (RFC5766) service for assisting the WebRTC instances in the web browsers to communicate to each other.

This allows multiple devices behind the same or different NAT routers to communicate with one another.

The `PEER_CONFIG` environment variable defined for orient is passed to both admin and drone via the generated `/config.js` URL on the orient web service.

### staoi

This repository you are looking at right now is the synthetic-target-area-of-interest repo (staoi).
The abbreviation was largely for this author's own sanity.

This container runs the python django based [synthetic-target-websvcs](ws/) git submodule from the [github.com/sofwerx/synthetic-target-websvcs](https://github.com/sofwerx/synthetic-target-websvcs) repository.

These web services reference the git submodules in `lib/swx/`

- [ObjectLoB](lib/swx/object_lob/) - [github.com/sofwerx/synthetic-target-line-of-bearing](https://github.com/sofwerx/synthetic-target-line-of-bearing)
  - Drone posted JPEG images run through tensorflow person identifier model, returned as an angle of bearing (aob) along with coordinates for TargetLoc to use.
- [TargetLoc](lib/swx/triangulator/) - [github.com/sofwerx/synthetic-target-triangulator](https://github.com/sofwerx/synthetic-target-triangulator)
  - 3 locations and lines of bearing (lob) translated to a single triangulated intersection coordinate
- [CoT](lib/swx/cot/) - [github.com/sofwerx/push-cursor-on-target](https://github.com/sofwerx/push-cursor-on-target)
  - Cursor on Target XML generation and posting to ATAK device for demonstration purposes.

