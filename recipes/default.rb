# Cookbook:: chef-study
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
execute "update-upgrade" do
    command "sudo apt-get update && sudo apt-get upgrade -y"
    action :run
end
package "apache2" do
  action :install
end

service "apache2" do
  action [:enable, :start]
end

document_root_1 = "/var/www/dev"
directory document_root_1 do
    mode "0755"
    recursive true
end
execute "enable-sites-dev" do
    command "a2ensite 000-dev"
    action :nothing
end
template "/etc/apache2/sites-available/000-dev.conf" do
    source "virtualhosts.erb"
    mode "0644"
    variables(
    :document_root => document_root_1,
    :servername => "www.desenvolvimento.com"
    )
    notifies :run, "execute[enable-sites-dev]"
    notifies :restart, "service[apache2]"
end
directory "/var/www/dev/public_html" do
    action :create
end
directory "/var/www/dev/logs" do
    action :create
end
template "/var/www/dev/public_html/index.html" do
    source "page.erb"
    mode "0644"
    variables(
    :name => "Desenvolvimento"
    )
end

document_root_2 = "/var/www/qa"
directory document_root_2 do
    mode "0755"
    recursive true
end
execute "enable-sites-qa" do
    command "a2ensite 000-qa"
    action :nothing
end
template "/etc/apache2/sites-available/000-qa.conf" do
    source "virtualhosts.erb"
    mode "0644"
    variables(
    :document_root => document_root_2,
    :servername => "www.qa.com"
    )
    notifies :run, "execute[enable-sites-qa]"
    notifies :restart, "service[apache2]"
end
directory "/var/www/qa/public_html" do
    action :create
end
directory "/var/www/qa/logs" do
    action :create
end
template "/var/www/qa/public_html/index.html" do
    source "page.erb"
    mode "0644"
    variables(
    :name => "Q&amp;A"
    )
end

document_root_3 = "/var/www/prod"
directory document_root_3 do
    mode "0755"
    recursive true
end
execute "enable-sites-prod" do
    command "a2ensite 000-prod"
    action :nothing
end
template "/etc/apache2/sites-available/000-prod.conf" do
    source "virtualhosts.erb"
    mode "0644"
    variables(
    :document_root => document_root_3,
    :servername => "www.producao.com"
    )
    notifies :run, "execute[enable-sites-prod]"
    notifies :restart, "service[apache2]"
end
directory "/var/www/prod/public_html" do
    action :create
end
directory "/var/www/prod/logs" do
    action :create
end
template "/var/www/prod/public_html/index.html" do
    source "page.erb"
    mode "0644"
    variables(
    :name => "Produção"
    )
end