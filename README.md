# isidicon
This Docker image contains the Isilon Data Insight Connector software that monitors Dell/EMC Isilon OneFS clusters

The connector works well when run from an interactive shell but failed when launched from a
process managing entity (initd, systemd, dockerd, supervisord). The reason is a fork or exec that
takes time and is interpreted as a process exit, causing new copies to be spawned.
A not-too-unelegant way of handling this is the "autorestart = false" option in supervisor.

To monitor multiple clusters, there are two options:
1) provide all clusters in a single configuration file
2) create a config file per cluster and run a connector per cluster

Option 2 consumes more memory (~ 50 MB / cluster) but provides:
- more configuration flexibility (or easier configuration per cluster)
- a more robust setup as the monitoring continues for other clusters when one of them fails
