target = "terraform"

out = ".kops-tf"

ami = "ami-03ed1c12a1dd84320"

master_size = "t2.micro"

master_volume_size = "20"

master_zone = "us-east-1a,us-east-1b,us-east-1c"

master_count = "5"

node_size = "t2.micro"

node_volume_size = "20"

node_count = "3"

zones = "us-east-1a,us-east-1b,us-east-1c"

networking = "flannel"

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

cloud_labels = "Owner=Kalada Opuiyo"

dns = "public"

kubernetes_version = "v1.10.0"

enable_dns_support = true

enable_dns_hostnames = true

instance_tenancy = "default"

subnets = {
  "1-public" = {
    cidr_block = "10.0.32.0/24"
    type       = "private"
  }

  "2-private" = {
    cidr_block = "10.0.16.0/24"
    type       = "public"
  }
}

availability_zone = ""

# private and/or public
route_tables = ["public", "private"]

vpc_cidr = "10.0.0.0/16"
