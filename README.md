# k3s-cluster-docker
to create k3s cluster

docker build --network=host -t k3s-ansible:latest .

```bash
docker run --rm \
    --privileged \
    --network host \
    --pid host \
    -v /:/host \
    -v /run/systemd:/run/systemd:ro \
    -v /var/run/dbus:/var/run/dbus:ro \
    -v ./ansible-vars-config:/ansible-vars-config:ro \
    k3s-ansible:latest
```
docker compose run --rm k3s-installer
