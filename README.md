# synthetic-target-area-of-interest
Identify and geolocate object(s) of interest using imagery and sensor data from multiple UAVs viewing a common target area, add / update corresponding feature on GIS map layer.


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

