rm -rf public/*
npm install
npm run build
sudo rm -rf /opt/1panel/apps/openresty/openresty/www/sites/127.0.0.1/index/*
sudo cp -r public/* /opt/1panel/apps/openresty/openresty/www/sites/127.0.0.1/index/
