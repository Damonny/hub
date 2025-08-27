#!/bin/bash
set -ex
OPENRESTYVER=1.25.3.2
HTTP=0.17.2
OPENSSL=1.2.1
cd $(dirname $0)

sed -i "s/deb.debian.org/${MIRROR}/g" /etc/apt/sources.list.d/debian.sources

apt update && apt upgrade -y
apt install -y zlib1g-dev libperl-dev libpcre3-dev libssl-dev libffi-dev wget gcc g++ make iperf3
apt install -y supervisor redis python3 python3-dev python3-pip

mkdir -p ${HOME}

pushd $(pwd)
# openresty
pushd $(pwd)
#cat openresty-1.25.3.2.tar.gz | tar -xz
#tar -zxvf openresty-${OPENRESTYVER}.tar.gz
mv openresty-${OPENRESTYVER}.tar.gz openresty-${OPENRESTYVER}.tar.gz.bak
wget https://openresty.org/download/openresty-${OPENRESTYVER}.tar.gz
tar -xvf openresty-${OPENRESTYVER}.tar.gz
cd openresty-${OPENRESTYVER} && ./configure --with-http_v2_module && make -j8 install
popd

#cat lua-resty-http-v0.17.2.tar.gz | tar -xz
wget -O lua-resty-http-${HTTP}.tar.gz https://github.com/ledgetech/lua-resty-http/archive/refs/tags/v${HTTP}.tar.gz
tar -zxvf lua-resty-http-${HTTP}.tar.gz
cp -pr lua-resty-http-${HTTP}/lib/resty/http*.lua /usr/local/openresty/lualib/resty

#cat lua-resty-openssl-1.2.1.tar.gz | tar -xz
mv lua-resty-openssl-${OPENSSL}.tar.gz lua-resty-openssl-${OPENSSL}.tar.gz.bak
wget -O lua-resty-openssl-${OPENSSL}.tar.gz https://github.com/fffonion/lua-resty-openssl/archive/refs/tags/${OPENSSL}.tar.gz
tar -zxvf lua-resty-openssl-${OPENSSL}.tar.gz
cp -pr lua-resty-openssl-${OPENSSL}/lib/resty/* /usr/local/openresty/lualib/resty
popd
