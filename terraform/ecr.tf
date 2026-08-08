resource "aws_ecr_repository" "backend" {
  name                 = "bbhealthapp-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, {
    Name = "bbhealthapp-backend"
  })
}

resource "aws_ecr_repository" "frontend" {
  name                 = "bbhealthapp-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, {
    Name = "bbhealthapp-frontend"
  })
}