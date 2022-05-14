echo "What is the (sub)domain name you want to use for the proxy? (Eg. something.yoursite.com)"                                                                                                                   
read ccdomain                                                                                                                                                     
                                                                                                                                                                  
echo "What is the IP address of your server and the port the program is running on (Eg. 192.168.1.101:8192)"                                                                                   
read ccip                                                                                                                                                         
                                                                                                                                                                  
echo " server {                                                                                                                                                   
        server_name $ccdomain;                                                                                                                                    
        listen 80;                                                                                                                                                
        listen [::]:80;                                                                                                                                           
        access_log /var/log/nginx/reverse-access.log;                                                                                                             
        error_log /var/log/nginx/reverse-error.log;                                                                                                               
        location / {                                                                                                                                              
                    proxy_pass http://$ccip;
                    # WebSocket support
                    proxy_http_version 1.1;
                    proxy_set_header Upgrade $http_upgrade;
                    proxy_set_header Connection "upgrade";
                    # IP Fix
                    proxy_set_header Host               $host;
                    proxy_set_header X-Real-IP          $remote_addr;
                    proxy_set_header X-Forwarded-Proto  $scheme;
                    proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
  }                                                                                                                                                               
} " > /etc/nginx/sites-available/$ccdomain.conf                                                                                                                   
                                                                                                                                                                  
ln -s /etc/nginx/sites-available/$ccdomain.conf /etc/nginx/sites-enabled/$ccdomain.conf                                                                           
                                                                                                                                                                  
certbot --nginx                                                                                                                                                   
                                                                                                                                                                  
echo "Your reverse proxy is now setup and should be available at https://$ccdomain" 
