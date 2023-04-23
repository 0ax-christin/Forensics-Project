SOURCE_PATH=/vagrant
 NGINX_PATH="/etc/nginx"
_certificates_dir="$NGINX_PATH/certs"
sudo mkdir -p "$_certificates_dir"
DEV_HOST="osctrl.dev"
_A_HOST="$ALL_HOST"
ALL_HOST="127.0.0.1"

_NAME="osctrl"

_cert_file="$_certificates_dir/$_NAME.crt"
_key_file="$_certificates_dir/$_NAME.key"
_cert_file_a="$_certificates_dir/$_NAME-admin.crt"
_key_file_a="$_certificates_dir/$_NAME-admin.key"
_dh_file="$_certificates_dir/dhparam.pem"
_dh_bits="2048"

sudo openssl req -x509 -newkey rsa:$_dh_bits -sha256 -days 365 -nodes \
  -keyout "$_key_file" -out "$_cert_file" -subj "/CN=$DEV_HOST" \
  -addext "subjectAltName=IP:$_A_HOST"


sudo openssl dhparam -out "$_dh_file" $_dh_bits &>/dev/null

cat "$SOURCE_PATH/deploy/nginx/nginx.conf" | sed "s|SERVER_USER|www-data|g" | sed "s|MODULES_CONF|/etc/nginx/modules-enabled/*.conf|g" | sudo tee "/etc/nginx/nginx.conf"

sudo mkdir -p "/etc/nginx/sites-available"
sudo mkdir -p "/etc/nginx/sites-enabled"

_T_INT_PORT="9000"
_T_PUB_PORT="443"

cat "$SOURCE_PATH/deploy/nginx/ssl.conf" | sed "s|PUBLIC_PORT|$_T_PUB_PORT|g" | sed "s|CER_FILE|$_cert_file|g" | sed "s|KEY_FILE|$_key_file|g" | sed "s|DHPARAM_FILE|$_dh_file|g" | sed "s|PRIVATE_PORT|$_T_INT_PORT|g" | sed "s|PRIVATE_HOST|tls.conf|g" | sudo tee "/etc/nginx"


sudo nginx -t
sudo service nginx restart