# synthetic-target-area-of-interest

Identify and geolocate object(s) of interest using imagery and sensor data from multiple UAVs viewing a common target area, add / update corresponding feature on GIS map layer.

## Environments

There are presently two deployments of this project here at Sofwerx. These are both submodule deployed through our [swx-devops](https://github.com/sofwerx/swx-devops) repo harness:

- [geo](https://github.com/sofwerx/swx-devops/tree/master/local/geo)
- [swx-gpu](https://github.com/sofwerx/swx-devops/tree/master/local/swx-gpu)

This is deployed using `docker-compose`, with the `.yml` file appropriate for each environment:

- [geo](geo.yml)
- [swx-gpu](swx-gpu.yml)

## Containers

The [docker-compose.yml](docker-compose.yml) is used by the above environments.

On a mac, with docker-engine installed as the default xhyve vm, you can:

    docker-compose up

Then open a browser to the orient port:

    http://localhost:9999

Open up one browser tab as an admin, and open three more browser tabs as drones, then click on the "Enable Triangulation" button.

# Current plan:

1. Orent Admin button or periodic trigger sends an "update" message to all drones
  - "update" message contains a timestamp to correlate responses
2. Orient Drones receive "update" message
  - Drone takes a canvas snapshot of the local stream and generates a PNG
  - Drone makes API call to obj_lob with PNG and current heading
  - Drone takes obj_lob result lob and timestamp and posts "updated" message back to Admin
3. Admin receives "updated" message for a timestamp.
 - If 3 "updated" messages have been received for a timestamp
   - Admin makes API call to triangulate with lat/long + lob
   - Admin takes lat/long result and draws the result on the map.

