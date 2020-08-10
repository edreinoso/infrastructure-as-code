module "example" {
  source = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/autoscaling"

  name = "${var.autoscaling-name}-${terraform.workspace}"

  # Launch configuration
  #
  # launch_configuration = "my-existing-launch-configuration" # Use the existing launch configuration
  # create_lc = false # disables creation of launch configuration
  lc_name                      = "${var.launch-configuration-name}-${terraform.workspace}"
  image_id                     = "${var.ami}"
  instance_type                = "${var.instance-type}"
  security_groups              = "${split(",", aws_security_group.nat-sg.id)}" #
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true
  user_data_base64             = base64encode("${file("build.sh")}")
  key_name                     = "${var.key-name-pub}"
  ebs_block_device = [
    {
      device_name           = "/dev/xvdk"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]
  root_block_device = [
    {
      volume_size           = "50"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.autoscaling-name}-${terraform.workspace}"
  vpc_zone_identifier       = ["${element(module.pub_subnet_2.subnet-id, 1)}", "${element(module.pub_subnet_1.subnet-id, 1)}"]
  health_check_type         = "${var.health-check}"
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 4
  wait_for_capacity_timeout = 0
  enabled_metrics           = "${var.enabled_metrics}"
  # service_linked_role_arn   = "${var.role}"

  tags = [
    {
      key                 = "Environment"
      value               = "${terraform.workspace}"
      propagate_at_launch = true
    },
    {
      key                 = "Template"
      value               = "${var.template}"
      propagate_at_launch = true
    },
    {
      key                 = "Creation Date"
      value               = "${var.created-on}"
      propagate_at_launch = true
    },
    {
      key                 = "Purpose"
      value               = "${var.purpose}"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "${var.application}"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.autoscaling-name}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_policy" "web_cluster_target_tracking_policy" {
  name                      = "testing-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = "${module.example.this_autoscaling_group_name}"
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "60"
  }
}

# # autoscaling policy to measure Cpu metrics to scale up by 1 server
# resource "aws_autoscaling_policy" "example-cpu-policy-scaleup" {
#   name                   = "example-cpu-policy-scaleup"
#   autoscaling_group_name = "${module.example.this_autoscaling_group_name}"
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "1"
#   cooldown               = "60"
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scaleup" {
#   alarm_name          = "example-cpu-alarm-scaleup"
#   alarm_description   = "example-cpu-alarm-scaleup"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "30"
#   dimensions = {
#     "AutoScalingGroupName" = "${module.example.this_autoscaling_group_name}"
#   }
#   actions_enabled = true
#   alarm_actions   = ["${aws_autoscaling_policy.example-cpu-policy-scaleup.arn}"]
# }

# # autoscaling measure to scale down by 1 server
# resource "aws_autoscaling_policy" "example-cpu-policy-scaledown" {
#   name                   = "example-cpu-policy-scaledown"
#   autoscaling_group_name = "${module.example.this_autoscaling_group_name}" # "${module.new-vpc.vpc-id}"
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = "-1"
#   cooldown               = "60"
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scaledown" {
#   alarm_name          = "example-cpu-alarm-scaledown"
#   alarm_description   = "example-cpu-alarm-scaledown"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "5"
#   dimensions = {
#     "AutoScalingGroupName" = "${module.example.this_autoscaling_group_name}" # need to get this value
#   }
#   actions_enabled = true
#   alarm_actions   = ["${aws_autoscaling_policy.example-cpu-policy-scaledown.arn}"]
# }
