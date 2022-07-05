resource "aws_instance" "ami" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.terraform_remote_state.remote.outputs.aws_sg_id]
  subnet_id = data.terraform_remote_state.remote.outputs.aws_subnet_id
  tags = {
    Name = "${var.COMPONENT}-ami"
  }
}

resource "null_resource" "app-deploy" {
  triggers = {
    instance_ids = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      timeout     = "4m"
      type        = "ssh"
      user        = "centos"
      private_key = file("~/.ssh/key")
      host     = aws_instance.ami.public_ip
    }

    inline = [
      "ansible-pull -U https://github.com/ChaitanyaChandra/ansible-lab.git spec-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=${var.ENV} -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USERNAME=${var.NEXUS_USERNAME} -e NEXUS_PASSWORD=${var.NEXUS_PASSWORD} -e PROJECT=${var.PROJECT} -i hosts"
    ]
  }
}

