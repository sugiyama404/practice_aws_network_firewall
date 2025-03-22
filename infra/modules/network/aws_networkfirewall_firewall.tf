# Network Firewall
resource "aws_networkfirewall_firewall" "main" {
  name                     = "main-firewall"
  firewall_policy_arn      = aws_networkfirewall_firewall_policy.main.arn
  vpc_id                   = aws_vpc.main.id
  delete_protection        = false
  subnet_change_protection = false

  subnet_mapping {
    subnet_id = aws_subnet.firewall_subnet.id
  }

  tags = {
    Name = "Main Network Firewall"
  }
}

# Firewall Policy
resource "aws_networkfirewall_firewall_policy" "main" {
  name = "main-firewall-policy"

  firewall_policy {
    # stateless_default_actions          = ["aws:forward_to_sfe"]
    # stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateless_default_actions          = ["aws:pass"]
    stateless_fragment_default_actions = ["aws:pass"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.allow_https.arn
    }
  }

  tags = {
    Name = "Main Firewall Policy"
  }
}

# Rule Group for Firewall
resource "aws_networkfirewall_rule_group" "allow_https" {
  capacity = 100
  name     = "allow-https"
  type     = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "PASS"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }
    }
  }

  tags = {
    Name = "AllowHTTPSandHTTPRules"
  }
}
