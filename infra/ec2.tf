resource "aws_instance" "poc-instance" {
  ami                         = "ami-0f918f7e67a3323f0" # Example AMI, replace with your desired AMI
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.poc-public-subnet-1.id
  key_name                    = aws_key_pair.public-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  root_block_device {
    volume_size = 16    # 👈 Disk size in GB
    volume_type = "gp3" # (optional) gp2, gp3, io1, etc.
  }

  tags = {
    Name = "poc-instance"
  }
  depends_on = [aws_key_pair.public-key, aws_security_group.jenkins-sg]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/.ssh/id_rsa") # Path to your private key
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install openjdk-21-jdk -y",
      "sudo apt update",
      "sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo 'deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt update",
      "sudo apt install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo apt install -y docker.io",
      "sudo usermod -aG docker ubuntu",
      "sudo usermod -aG docker jenkins"
    ]
  }
}

resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins instance"
  vpc_id      = aws_vpc.poc-vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "public-key" {
  key_name   = "public-key"
  public_key = file("${path.module}/.ssh/id_rsa.pub")
  # Path to your public key
}

