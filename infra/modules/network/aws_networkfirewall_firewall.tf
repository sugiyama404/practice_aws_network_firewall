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
      resource_arn = aws_networkfirewall_rule_group.block_as_numbers.arn
    }

    stateful_default_actions = ["aws:drop"]
  }
}

# ドメイン名ベースのルールグループ（FQDNベース）
resource "aws_networkfirewall_rule_group" "allow_google" {
  capacity = 100
  name     = "allow-google-domain"
  type     = "STATEFUL"

  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = ["google.com", "www.google.com"]
      }
    }

    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
  }
}

# AS番号ベースのルールグループ
resource "aws_networkfirewall_rule_group" "block_as_numbers" {
  capacity = 100
  name     = "block-as-numbers"
  type     = "STATEFUL"

  rule_group {
    rule_variables {
      ip_sets {
        key = "GOOGLE_AS_RANGES"
        ip_set {
          definition = [
            "15169",
            "36039",
            "36040",
            "15169",
          ] # Googleの主要なAS番号
        }
      }
    }

    rules_source {
      stateful_rule {
        action = "PASS"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "IP"
          source           = "$GOOGLE_AS_RANGES"
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }

      stateful_rule {
        action = "DROP"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "IP"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }
    }
  }
}
