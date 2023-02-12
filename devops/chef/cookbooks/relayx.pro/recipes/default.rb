#
# Cookbook:: relayx.pro
# Recipe:: default
#
# Copyright:: 2023, Powco, All Rights Reserved.
#

apt_package 'nginx'
apt_package 'certbot'
apt_package 'python3-certbot-nginx'

execute "letsencrypt --nginx certonly -n -d relayx.pro --agree-tos --email ops@pow.co"

template "/etc/nginx/sites-enabled/relayx.pro" do
  source "nginx.conf.erb"
end

service "nginx" do
  action :restart
end

cron 'update letsencrypt certificates' do
  action :create
  minute '0'
  hour '0'
  day '*'
  command 'sudo letsencrypt --nginx renew'
end

