resource "aws_ecs_cluster" "ecs" {
    name= "app_cluster"
}
resource "aws_ecs_service" "service" {
    name = "service"
    cluster = aws_ecs_cluster.ecs.arn
    launch_type = "FARGATE"
    enable_execute_command = true
    task_definition = aws_ecs_task_definition.td.arn
    desired_count = 1
    
    network_configuration {
      assign_public_ip = true
      security_groups = [aws_security_group.sg.id]
      subnets = [aws_subnet.sn1.id, aws_subnet.sn2.id, aws_subnet.sn3.id]
    }
}
resource "aws_ecs_task_definition" "td" {
    container_definitions = jsonencode([
        {
            name = "app"
            image = "515396172591.dkr.ecr.ap-south-1.amazonaws.com/app_repo"
            cpu = 256
            memory = 512
            essential = true
            portMappings = [
                {
                    containerPort = 80
                    hostPort = 80
                }
            ]
        }
])
    family = "app"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    network_mode = "awsvpc"
    task_role_arn = "arn:aws:iam::515396172591:role/ecstaskexecution"
    execution_role_arn = "arn:aws:iam::515396172591:role/ecstaskexecution"
}