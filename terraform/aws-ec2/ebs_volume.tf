locals {
  linux_device_name = "/dev/sdh"
}

resource "aws_ebs_volume" "data_volume" {
  type              = "gp2"
  availability_zone = local.availability_zone_name
  size              = 4 # GiB

  tags = {
    Name = "DataVolume"
  }
}

resource "aws_volume_attachment" "ebs_data_volume_attachment" {
  device_name = local.linux_device_name
  volume_id   = aws_ebs_volume.data_volume.id
  instance_id = aws_instance.example_http_instance.id
}
