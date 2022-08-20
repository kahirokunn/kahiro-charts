# required: yq version >= 4.0.0

update:
	-rm -rf .tmp
	mkdir .tmp
	git clone https://github.com/kubernetes-csi/external-snapshotter.git .tmp/code
	@make update-crds
	@make update-templates
	@make update-app-version
	@make patch-version
	rm -rf .tmp

update-crds:
	rm charts/external-snapshotter/crds/*
	kubectl kustomize .tmp/code/client/config/crd | yq 'del(.metadata.creationTimestamp)' > charts/external-snapshotter/crds/external-snapshotter.crds.yaml

update-templates:
	rm charts/external-snapshotter/templates/*
	kubectl kustomize .tmp/code/deploy/kubernetes/snapshot-controller | yq 'del(.metadata.namespace)' > charts/external-snapshotter/templates/snapshot-controller.yaml

update-app-version:
	sh bin/update-app-version.sh

patch-version:
	sh bin/patch-version.sh

release:
	rsync -ahv --delete charts/ stable
	cd stable && helm package external-snapshotter
	helm repo index stable
