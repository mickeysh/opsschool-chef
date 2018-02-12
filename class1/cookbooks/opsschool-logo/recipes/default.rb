log 'message' do
    message 'update apt index cache'
    level :info
end

# update apt cache
apt_update 'update'

log 'message' do
    message 'install nginx'
    level :info
end

# install nginx 
apt_package 'nginx' do
    action :install
end

log 'message' do
    message 'create site directory'
    level :info
end

# create the site directory 
directory "#{node['class1']['path']}" do
    owner node['class1']['user']
    group node['class1']['user']
    action :create
end

log 'message' do
    message 'create site html'
    level :info
end

# copy the site html file from our cookbook file
cookbook_file "#{node['class1']['path']}/index.html" do
    source 'logo.html'
    owner node['class1']['user']
    group node['class1']['user']
    action :create
end

log 'message' do
    message 'download logo'
    level :info
end

remote_file "#{node['class1']['path']}/logo.png" do
    source node['class1']['logo_url']
    owner node['class1']['user']
    group node['class1']['user']
    action :create
end

log 'message' do
    message 'fix permissions'
    level :info
end

directory "#{node['class1']['path']}/" do
    owner node['class1']['user']
    group node['class1']['user']
    recursive true
end

log 'message' do
    message 'disable default site'
    level :info
end

file '/etc/nginx/sites-enabled/default' do
    action :delete
end

log 'message' do
    message 'create nginx site config'
    level :info
end

template '/etc/nginx/sites-available/logo' do
    source 'logo.nginx-conf.erb'
end

log 'message' do
    message 'enable site'
    level :info
end

link '/etc/nginx/sites-enabled/logo' do
    to '/etc/nginx/sites-available/logo'
    link_type :symbolic
end

log 'message' do
    message 'reload nginx'
    level :info
end

service "nginx" do
    action :restart
end
  

