# From Deploying 'container of cats' using Fargate Demo
resource "aws_ecs_cluster" "foo" {
  name = "allthecats"

  tags = {
    Name  = "All the cats"
  }
}

resource "aws_ecs_task_definition" "containerofcats_tf" {
  family = "containerofcats"
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name = "containerofcats"
      image = "docker.io/acantril/containerofcats"
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])
}