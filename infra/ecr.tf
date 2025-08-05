resource "aws_ecr_repository" "poc-ecr-1" {
  name                 = "poc-ecr-frontend"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "poc-ecr"
  }
}
resource "aws_ecr_repository" "poc-ecr" {
  name                 = "poc-ecr-backend"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "poc-ecr"
  }
}

