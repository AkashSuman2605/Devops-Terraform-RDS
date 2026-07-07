resource "aws_security_group" "alb_sg" {

  name   = "alb-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}
resource "aws_security_group" "ecs_sg" {

  name   = "ecs-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}
resource "aws_ecs_cluster" "cluster" {

  name = var.cluster_name

}
resource "aws_cloudwatch_log_group" "ecs_logs" {

  name = "/ecs/app"

  retention_in_days = 7

}
resource "aws_iam_role" "ecs_execution_role" {

  name = var.execution_role_name

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ecs-tasks.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}
resource "aws_iam_role_policy_attachment" "ecs_execution_role" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}
resource "aws_lb" "alb" {

  name               = "ecs-alb"

  internal           = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = var.public_subnet_ids

}
resource "aws_lb_target_group" "target_group" {

  name = "ecs-target-group"

  port = var.container_port

  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "ip"

  health_check {

    path = "/"

    protocol = "HTTP"

  }

}
resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.target_group.arn

  }

}
resource "aws_ecs_task_definition" "task" {

  family = "hotel-booking"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = "256"

  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([

    {

      name = "hotel-app"

      image = var.container_image

      essential = true

      portMappings = [

        {

          containerPort = var.container_port

          hostPort = var.container_port

        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs_logs.name

          awslogs-region = "ap-south-1"

          awslogs-stream-prefix = "ecs"

        }

      }

    }

  ])

}
resource "aws_ecs_service" "service" {

  name = "hotel-service"

  cluster = aws_ecs_cluster.cluster.id

  task_definition = aws_ecs_task_definition.task.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.private_subnet_ids

    security_groups = [

      aws_security_group.ecs_sg.id

    ]

    assign_public_ip = false

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.target_group.arn

    container_name = "hotel-app"

    container_port = var.container_port

  }

  depends_on = [

    aws_lb_listener.listener

  ]

}
