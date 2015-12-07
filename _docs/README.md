# Minio on Kubernetes

Please see [the top level README](https://github.com/deis/minio/blob/master/README.md) for a description of what this project does.

# Example Client Usage

Assuming you've installed the Kubernetes service and replication controller (run `make kube-secrets kube-service kube-rc` to do so), you can access the Minio server via the Kubernetes service IP and port. Assuming you have the Minio [`mc`](https://github.com/minio/mc) CLI, installed in your container, here's how you'd configure the CLI and create a new bucket, all from inside Kubernetes:

```bash
# The following two commands assume that you've mounted the 'minio-user' secret under /var/run/secrets/object/store.
# If you've mounted the secret elsewhere, adjust as necessary.
ACCESS_KEY_ID=`cat /var/run/secrets/object/store/access-key-id`
ACCESS_SECRET_KEY=`cat /var/run/secrets/object/store/access-secret-key`
BASE_SERVER="http://${DEIS_MINIO_SERVICE_HOST}:${DEIS_MINIO_SERVICE_PORT}"
mc config host add $BASE_SERVER $ACCESS_KEY_ID $ACCESS_KEY_SECRET
mc mb "${BASE_SERVER}/mybucket"
```
