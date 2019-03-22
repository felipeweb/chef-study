#
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

  node["chef_study"]["sites"].each do |sitename, data|
    
    document_root = "/var/www/#{sitename}"
    directory document_root do
        mode "0755"
        recursive true
    end
    execute "enable-sites" do
        command "a2ensite 000-#{sitename}"
        action :nothing
    end
    template "/etc/apache2/sites-available/000-#{sitename}.conf" do
        source "virtualhosts.erb"
        mode "0644"
        variables(
        :document_root => document_root,
        :servername => data["servername"]
        )
        notifies :run, "execute[enable-sites]"
        notifies :restart, "service[apache2]"
    end
    directory "/var/www/#{sitename}/public_html" do
        action :create
    end
    directory "/var/www/#{sitename}/logs" do
        action :create
    end
    template "/var/www/#{sitename}/public_html/index.html" do
        source "page.erb"
        mode "0644"
        variables(
        :name => data["name"]
        )
    end
  end
