resource "alicloud_vpc" "vpc" {
  vpc_name   = "capstone"
  cidr_block = "10.0.0.0/8"
}

data "alicloud_zones" "avalible_zones" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vswitch" "public" {
  vswitch_name = "public"
  cidr_block   = "10.0.1.0/24"
  vpc_id       = alicloud_vpc.vpc.id
  zone_id      = data.alicloud_zones.avalible_zones.zones.0.id
}

resource "alicloud_vswitch" "public-b" {
  vswitch_name = "public-b"
  cidr_block   = "10.0.3.0/24"
  vpc_id       = alicloud_vpc.vpc.id
  zone_id      = data.alicloud_zones.avalible_zones.zones.1.id
}

resource "alicloud_vswitch" "private" {
  vswitch_name = "private"
  cidr_block   = "10.0.2.0/24"
  vpc_id       = alicloud_vpc.vpc.id
  zone_id      = data.alicloud_zones.avalible_zones.zones.0.id
}

resource "alicloud_nat_gateway" "nat" {
  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = "capstone-nat"
  vswitch_id       = alicloud_vswitch.public.id
  payment_type     = "PayAsYouGo"
  nat_type         = "Enhanced"
}

resource "alicloud_eip_address" "nat" {
  description               = "nat"
  address_name              = "nat"
  netmode                   = "public"
  bandwidth                 = "100"
  payment_type              = "PayAsYouGo"
  internet_charge_type      = "PayByTraffic"
}

resource "alicloud_eip_association" "nat" {
  allocation_id = alicloud_eip_address.nat.id
  instance_id   = alicloud_nat_gateway.nat.id
  instance_type = "Nat"
}

resource "alicloud_snat_entry" "http_private" {
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private.id
  snat_ip           = alicloud_eip_address.nat.ip_address
}

resource "alicloud_route_table" "default" {
  description      = "private"
  vpc_id           = alicloud_vpc.vpc.id
  route_table_name = "private"
  associate_type   = "VSwitch"
}

resource "alicloud_route_entry" "private" {
  route_table_id        = alicloud_route_table.default.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.nat.id
}

resource "alicloud_route_table_attachment" "private" {
  vswitch_id     = alicloud_vswitch.private.id
  route_table_id = alicloud_route_table.default.id
}