### Set Up a Systemd Service

```sh
sudo cp ginh.service /etc/systemd/system/ginh.service
sudo systemctl daemon-reload

sudo systemctl start ginh
sudo systemctl enable ginh
```


### nginx config

```nginx
server {

    server_name ov.unliminet-th.com;

    root /var/www/ov.unliminet-th.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /ginh/ {
        proxy_pass http://localhost:8081/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/ov.unliminet-th.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/ov.unliminet-th.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
```
