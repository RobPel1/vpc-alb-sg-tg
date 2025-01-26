resource "aws_lb_target_group" "tg1" {
  name = "alb-target-gp"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.v1.id  
  health_check {
    enabled = true 
    healthy_threshold = 3 
    interval = 100 
    path = "/"
    matcher = 200
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 6 
    unhealthy_threshold = 3
  }
}
resource "aws_lb_target_group_attachment" "ltg1" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id = aws_instance.server1.id 
  port = 80
}
resource "aws_lb_target_group_attachment" "ltg2" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id = aws_instance.server2.id 
  port = 80  // integer int
}

resource "aws_lb" "lb1" {
  name = "alb-loadbalancer"
  internal = false 
  load_balancer_type = "application"  # string
  security_groups = [ aws_security_group.alb.id ]
  subnets = [ aws_subnet.pub1.id, aws_subnet.pub2.id ]
  enable_deletion_protection = false // boolean
  tags ={
    Env = "dev"
  }
}
resource "aws_lb_listener" "listenner1" {
  load_balancer_arn = aws_lb.lb1.arn 
  port = 80 
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}