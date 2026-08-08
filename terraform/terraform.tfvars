project_name = "bbhealthapp"

environment = "dev"

aws_region = "us-west-2"

cluster_name = "bbhealthapp-dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

availability_zones = [
  "us-west-2a",
  "us-west-2b"
]

node_instance_type = "t3.medium"

node_desired_size = 2

node_min_size = 1

node_max_size = 3

db_instance_class = "db.t3.micro"

db_name = "bbhealthapp"

db_username = "admin"

db_password = "ChangeMe123"