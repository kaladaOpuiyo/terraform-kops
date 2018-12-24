acl = "private"

admin_access = "0.0.0.0/0"

# #CoreOs AMI
# ami = "ami-03ed1c12a1dd84320"

#Default AMI
ami = "ami-03b850a018c8cd25e"

api_loadbalancer_type = ""

associate_public_ip = "true"

authorization = "RBAC"

bastion = "false"

cloud = "aws"

cloud_labels = "Owner=Kalada Opuiyo"

dns = "public"

enable_dns_hostnames = "true"

enable_dns_support = "true"

encrypt_etcd_storage = "true"

env = "dev"

force_destroy = "true"

instance_tenancy = "default"

kubernetes_version = "v1.11.5"

kubelet_flags = ["authorizationMode:Webhook", "authenticationTokenWebhook:true"]

master_count = "1" #BUGGY

master_size = "t2.medium" #UPDATEABLE

master_volume_size = "20" #UPDATEABLE

master_zone = "us-east-1a" #BUGGY

max_nodes = "5"

min_nodes = "2"

network_cidr = "10.0.0.0/16"

networking = "calico"

node_count = "2" #UPDATEABLE

node_size = "t2.medium" #UPDATEABLE

node_volume_size = "20" #UPDATEABLE

out = ".kops-tf"

output = "yaml"

region = "us-east-1"

target = "terraform"

topology = "public"

vpc_cidr = "10.0.0.0/16"

zones = "us-east-1a,us-east-1c"

######### NOT SETUP FUTURE UPGRADE - SUBNET MANAGEMENT #########

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
