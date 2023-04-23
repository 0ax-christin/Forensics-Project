sudo apt update

# Install NTPd
sudo apt install ntp
# Install Postgres
#https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart

sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service
sudo apt enable postgresql

# Install Redis
_REDIS_CONF=/etc/redis/redis.conf
sudo apt install redis-server

sudo apt install git wget curl gcc make openssl rsync bc tmux build-essential nginx

#Install Golang
_GO_LINK="https://go.dev/dl/go1.20.3.linux-amd64.tar.gz"

wget $_GO_LINK
rm -rf /usr/local/go && tar -C /usr/local -xzvf  ${_GO_LINK##*/}
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
