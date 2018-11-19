target = "terraform"

master_size = "t2.medium"

master_volume_size = "20"

master_zone = "us-east-1a"

master_count = "1"

node_size = "t2.medium"

node_volume_size = "20"

node_count = "3"

zones = "us-east-1a,us-east-1b,us-east-1c"

networking = "calico"

network_cidr = "172.20.0.0/16"

topology = "public"

api_loadbalancer_type = ""

associate_public_ip = "true"

output = "yaml"

authorization = "RBAC"

cloud = "aws"

encrypt_etcd_storage = "true"

env = "dev"

region = "us-east-1"

force_destroy = "true"

acl = "private"

bastion = "false"

admin_access = "0.0.0.0/0"

cloud_labels = ""

dns = "public"

kubernetes_version = "v1.10.0"
