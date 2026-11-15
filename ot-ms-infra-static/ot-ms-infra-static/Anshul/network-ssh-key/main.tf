# Ticket: Terraform static code to configure SSH Key
# REPLACE the public_key below with your own public key (cat ~/.ssh/id_ed25519.pub). Never put the PRIVATE key here.

resource "aws_key_pair" "main" {
  key_name   = "ot-ms-dev-key"
  public_key = "ssh-ed25519 AAAAREPLACE_WITH_YOUR_PUBLIC_KEY dev@ot-ms"

  tags = {
    Name        = "ot-ms-dev-key"
    Application = "network"
    Owner       = "Anshul"
    Environment = "dev"
    CostCenter  = "CC-OT-DEV-1001"
  }
}

output "key_name" {
  value = aws_key_pair.main.key_name
}
