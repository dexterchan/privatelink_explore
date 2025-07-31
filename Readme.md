
in the main vm, install nginx
```
sudo amazon-linux-extras install -y nginx1
sudo systemctl enable nginx
sudo systemctl start nginx
```

In NLB, the security group need to whitelist the IP address of the privatelink client.  
But for NACL of the subnet hosting NLB, blocking IP CIDR of privatelink client still allow traffic.