#!/bin/bash
#

# 系统初始化配置
update_dep()
{
    sudo apt-get update
    sudo apt-get upgrade

    sudo apt-get install g++ gcc make cmake
    # Do you want to continue? [Y/n]

    mkdir ~/box
    mkdir ~/project
    mkdir ~/etc
}

# 安装zsh, oh-my-zsh, autojump, autosuggestions(命令历史)
# 设置zeta主题
setup_zsh()
{
    # 安装oh-my-zsh
    echo $SHELL/bin/bash
    cd ~/box/

    sudo apt-get install git
    #[sudo] password for gynmi:
    #Do you want to continue? [Y/n]

    sudo apt-get install zsh
    #[sudo] password for gynmi:
    #Do you want to continue? [Y/n]
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    # 设置为zsh
    chsh -s /bin/zsh
    #Password:

    # 直接跳到目录
    sudo apt-get install autojump
    git clone https://github.com/wting/autojump.git
    cd autojump/
    ./install.py #运行安装脚本
    # 修改 ~/.zshrc文件, 添加插件 plugins=(autojump)

    # 自动提示, $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    # 修改 ~/.zshrc文件, 添加插件 plugins=(zsh-autosuggestions)

    # zsh自动添加插件, 插入.zshrc文件属性 plugins 里面
    sed -i '/plugins=(.*)/s/)/ autojump&/' ~/.zshrc
    sed -i '/plugins=(.*)/s/)/ zsh-autosuggestions&/' ~/.zshrc

    wget -P ~ https://github.com/gynmi/coding/blob/master/zeta.zsh-theme
    mv ~/zeta.zsh-theme ~/.oh-my-zsh/themes/

    sed -i 's/robbyrussell/zeta/g' ~/.zshrc
    # sed -i 's/zeta/robbyrussell/g' ~/.zshrc
}

# 安装nodejs版本管理器(需要定时更新)
install_nvm()
{
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash

    . ~/.nvm/nvm.sh

    nvm install v6.4.0

    npm install -g pm2 eslint bower nrm babel hexo

    pm2 install pm2-logrotate
    pm2 set pm2-logrotate:retain 3
}

# 开启Swap
setup_swap()
{
    sudo dd if=/dev/zero of=/var/swap bs=1M count=1024
    sudo mkswap /var/swap
    sudo swapon /var/swap
    # 此时用free -m查看, 发现swap出现了
    # 自动挂载Swap
    sudo vim /etc/fstab
    # 设置swap用于重启后自动设置
    # /var/swap    swap              swap    defaults        0 0
    sudo sh -c 'echo "/var/swap      swap            swap    defaults        0 0" >> /etc/fstab'
    # NOTICE: 阿里云默认是不让用户使用swap
    #         编辑/etc/rc.d/rc.local
    #         将文件中的swapoff行注释或删掉
}

install_docker()
{
    curl -sSL https://get.daocloud.io/docker | sh

    sudo usermod -aG docker $USER
    #password

    sudo service docker start
    #password

    # latest
    docker pull mysql
    docker pull mongo
    docker pull redis
    docker pull rabbitmq
}

start_docker_container()
{
    wget -P ~/etc https://github.com/gynmi/coding/blob/master/mysql.cnf

    # 启动mysql
    docker run --name mysql \
               -p 127.0.0.1:3306:3306 \
               -e MYSQL_ROOT_PASSWORD=qwer1234 \
               -v /data/mysql:/var/lib/mysql \
               -v ~/etc:/etc/mysql/conf.d \
               -d mysql:latest

    docker ps -la

    # 启动mongodb
    docker run --name mongo \
               -d mongo

    docker exec -it mongo mongo admin
    use admin;
    db.createUser({ user: "$USER",pwd: "qwer1234",roles: [{ role: "root", db: "admin" }]});

    db.auth("$USER", "qwer1234");

    use Shadowsocks-Manager;
    db.createUser({ user: "vpn", pwd: "qwer1234",roles: [{ role: "readWrite", db: "Shadowsocks-Manager"}]});


    # 启动redis

    # 启动rabbitmq

}

# 安装nginx
install_nginx()
{
    sudo useradd -r -M nginx
    #password

    #ubuntu 14.04
    sudo apt-get install libpcre3 libpcre3-dev libpcrecpp0 libssl-dev zlib1g-dev

    # wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz
    # tar zxvf pcre-8.12.tar.gz

    wget -P ~/box http://nginx.org/download/nginx-1.11.3.tar.gz

    cd ~/box/ && tar zxvf nginx-1.11.3.tar.gz
    cd ~/box/nginx-1.11.3/
    # --with-http_geoip_module   ip-国省市

    ./configure --prefix=/usr/local/nginx\
                --user=nginx\
                --group=nginx\
                --with-http_ssl_module\
                --with-http_realip_module\
                --with-http_stub_status_module

    make && sudo make install

    rm -rf ~/box/nginx-1.11.3/

    # NOTICE: Copy nginx init script to /etc/init.d/

    # support PHP
    # sudo apt-get install spawn-fcgi php5-fpm
}

install_ss()
{
    cd ~/project

    git clone https://github.com/shadowsocks/shadowsocks

    cd ~/project/shadowsocks/

    # 可能需要python-setuptools
    python setup.py build
    sudo python setup.py install

    # Shadowsocks-Manager
    git clone https://github.com/shadowsocks/shadowsocks-manager.git

    cd ~/project/shadowsocks-manager/

    npm install && bower install
}


echo -e "\033[----------------------------------\033[0m"
echo -e "\033[Please enter your choise:\033[0m"
echo -e "\033[(0) update_dep\033[0m"
echo -e "\033[(1) setup_zsh\033[0m"
echo -e "\033[(2) setup_swap\033[0m"
echo -e "\033[(3) install_nvm\033[0m"
echo -e "\033[(4) install_docker\033[0m"
echo -e "\033[(5) start_docker_container\033[0m"
echo -e "\033[(6) install_nginx\033[0m"
echo -e "\033[(7) install_ss\033[0m"
echo -e "\033[(8) install_all\033[0m"
echo -e "\033[(9) Exit Menu\033[0m"
echo -e "\033[----------------------------------\033[0m"
read input

case $input in
    0)
    echo update_dep
    update_dep;;
    1)
    echo setup_zsh
    setup_zsh;;
    2)
    echo setup_swap
    setup_swap;;
    3)
    echo install_nvm
    install_nvm;;
    4)
    echo install_docker
    install_docker;;
    5)
    echo start_docker_container
    start_docker_container;;
    6)
    echo install_nginx
    install_nginx;;
    7)
    echo install_ss
    install_ss;;
    8)
    echo install_all
    update_dep
    setup_zsh
    setup_swap
    install_nvm
    install_docker
    start_docker_container;;
    9)
    exit;;
esac



update_dep
setup_zsh
setup_swap
install_nvm
install_docker
# start_docker_container
# install_nginx
# install_ss
