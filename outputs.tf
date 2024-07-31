output "tls_private_key" {
  value = tls_private_key.sshkey.private_key_pem
   sensitive = true
}

output "tls_public_key" {
  value = tls_private_key.sshkey.public_key_openssh
   sensitive = true
}

