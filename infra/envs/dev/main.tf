module "network" {
  source = "../../modules/network"

  vpc_cidr = var.vpc_cidr

  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr

  private_app_subnet_1_cidr = var.private_app_subnet_1_cidr
  private_app_subnet_2_cidr = var.private_app_subnet_2_cidr

  private_db_subnet_1_cidr = var.private_db_subnet_1_cidr
  private_db_subnet_2_cidr = var.private_db_subnet_2_cidr

  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}
module "ecs" {

  source = "../../modules/ecs"

  vpc_id = module.network.vpc_id

  public_subnet_ids = module.network.public_subnet_ids

  private_subnet_ids = module.network.private_app_subnet_ids

  container_image = "nginx:latest"

  container_port = 80

  desired_count = 1

  execution_role_name = "ecsExecutionRole"

  cluster_name = "hotel-cluster"

}
