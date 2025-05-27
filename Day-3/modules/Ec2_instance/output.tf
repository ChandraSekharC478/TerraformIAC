output "public_ip_adress" {
   value= aws_instance.examplemodule.public_ip
}
output "username" {
    value = aws_instance.examplemodule.user_data
  
}