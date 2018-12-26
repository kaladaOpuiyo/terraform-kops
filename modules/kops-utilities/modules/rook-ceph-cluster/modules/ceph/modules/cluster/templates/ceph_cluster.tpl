#################################################################################
# The Ceph Cluster CRD example
#################################################################################
apiVersion: ceph.rook.io/v1
kind: CephCluster
metadata:
  name: rook-ceph
  namespace: rook-ceph
spec:
  cephVersion:
    # For the latest ceph images, see https://hub.docker.com/r/ceph/ceph/tags
    image: ceph/ceph:v13.2.2-20181023
  dataDirHostPath: /var/lib/rook
  dashboard:
    enabled: true
  mon:
    count: 3
    allowMultiplePerNode: true
  storage:
    useAllNodes: true
    useAllDevices: false
    config:
      databaseSizeMB: "1024"
      journalSizeMB: "1024"
---
  apiVersion: v1
  kind: Service
  metadata:
    name: rook-ceph-mgr-dashboard-external-https
    namespace: rook-ceph
    labels:
      app: rook-ceph-mgr
      rook_cluster: rook-ceph
  spec:
    ports:
    - name: dashboard
      port: 8443
      protocol: TCP
      targetPort: 8443
    selector:
      app: rook-ceph-mgr
      rook_cluster: rook-ceph
    sessionAffinity: None
    type: NodePort