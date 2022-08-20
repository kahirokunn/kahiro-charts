cp charts/external-snapshotter/Chart.yaml .tmp/Chart.yaml
yq '.version | capture("(?P<n>[0-9]$)") | .n tag= "!!int" | load(".tmp/Chart.yaml") * {"version": (load(".tmp/Chart.yaml") | .version | capture("(?P<n>[0-9]+\.[0-9]+\.)[0-9]+$") | .n) + .n + 1}' .tmp/Chart.yaml > charts/external-snapshotter/Chart.yaml
