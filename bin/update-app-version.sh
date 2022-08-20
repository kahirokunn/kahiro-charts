cp charts/external-snapshotter/Chart.yaml .tmp/Chart.yaml
kubectl kustomize .tmp/code/deploy/kubernetes/snapshot-controller | yq 'select(.kind == "Deployment") | .spec.template.spec.containers[] | select(.name == "snapshot-controller") | .image | capture(".*v(?P<n>[0-9\.]+)") | load(".tmp/Chart.yaml") * {"appVersion": .n}' > charts/external-snapshotter/Chart.yaml
