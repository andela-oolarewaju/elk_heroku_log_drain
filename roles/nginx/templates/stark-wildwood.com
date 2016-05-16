server {
  listen 443 ssl;

  #Make site accessible from http://localhost/
  server_name 192.168.33.10;
  access_log            /var/log/nginx/access.log;
  auth_basic "Restricted";
  auth_basic_user_file /etc/nginx/conf.d/kibana.htpasswd;
  ssl_certificate /etc/nginx/ssl/server.crt;
  ssl_certificate_key /etc/nginx/ssl/server.key;

  location / {
    proxy_pass http://localhost:5601;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
}
server {
  listen 80;
  return 301 https://192.168.33.10;
}