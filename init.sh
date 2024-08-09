git pull https://github.com/Apiclo/Apiclo.github.io.git
git checkout main
rm -rf public/*
npm install
npm run build
rm -rf /opt/1panel/apps/openresty/openresty/www/sites/4000/index/*
cp -r public/* /opt/1panel/apps/openresty/openresty/www/sites/4000/index/
