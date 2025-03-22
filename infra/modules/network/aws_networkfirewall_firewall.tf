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
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.allow_google.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.allow_outbound_services.arn
    }
  }
}

# ドメイン名ベースのルールグループ（FQDNベース）
resource "aws_networkfirewall_rule_group" "allow_google" {
  capacity = 100
  name     = "allow-google-domains"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = ["google.com", "www.google.com"]
      }
    }
  }
}

# グローバルIPアドレス許可ルール（ポートベース）
resource "aws_networkfirewall_rule_group" "allow_outbound_services" {
  capacity = 100
  name     = "allow-outbound-http-https-dns"
  type     = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "PASS"
        header {
          destination      = "ANY"
          destination_port = "443"
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

      stateful_rule {
        action = "PASS"
        header {
          destination      = "ANY"
          destination_port = "80"
          direction        = "ANY"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }

      stateful_rule {
        action = "PASS"
        header {
          destination      = "ANY"
          destination_port = "53"
          direction        = "ANY"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["3"]
        }
      }

      stateful_rule {
        action = "PASS"
        header {
          destination      = "ANY"
          destination_port = "53"
          direction        = "ANY"
          protocol         = "UDP"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["4"]
        }
      }
    }
  }
}
