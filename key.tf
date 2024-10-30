resource "alicloud_ecs_key_pair" "my_key" {
  key_pair_name = "my_key1"
  key_file = "my_key.pem"
}