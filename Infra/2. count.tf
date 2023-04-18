variable "service" {
  default = [
    {
      ami           = "ami-06e46074ae430fba6"
      instance_type = "t2.micro"
      name          = "Amazon-Linux"
    },
    {
      ami           = "ami-007855ac798b5175e"
      name          = "ubuntu"
    }
  ]
}

resource "aws_instance" "instances" {
  count = length(var.service)

  ami           = var.service[count.index].ami
  instance_type = lookup(var.service[count.index], "instance_type" , "t3.micro")

  tags = {
    Name = var.service[count.index].name
  }
}

