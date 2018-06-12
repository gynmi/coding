#!/bin/bash
#

# run start!
# curl -sSL https://raw.githubusercontent.com/gynmi/coding/master/server_init.sh | sh

# 系统初始化配置
update_dep()
{
    echo "installing update_dep!"
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

    wget -P ~ https://raw.githubusercontent.com/gynmi/coding/master/zeta.zsh-theme

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
    
    sudo gpasswd -a ${USER} docker

    sudo service docker start
    #password
    
    newgrp - docker
}

start_docker_container()
{
    wget -P ~/etc https://raw.githubusercontent.com/gynmi/coding/master/mysql.cnf

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
               -p 127.0.0.1:27017:27017 \
               -v /data/mongo:/data/db \
               -d mongo \
               --auth

    # db.system.users.find();
    # db.system.users.remove({user:"$USER"});
    # db.auth('vpn', 'qwer1234');

    # docker exec -it mongo mongo admin
    # db.createUser({ user: "gynmi",pwd: "qwer1234",roles: [{ role: "root", db: "admin" }]});

    # docker exec -it mongo mongo Shadowsocks-Manager
    # db.createUser({ user: "vpn", pwd: "qwer1234",roles: [{ role: "readWrite", db: "Shadowsocks-Manager"}]});


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


echo "\033[33m----------------------------------\033[0m"
echo "\033[32mPlease enter your choise:\033[0m"
echo "\033[36m(0)\033[0m \033[34mupdate_dep\033[0m"
echo "\033[36m(1)\033[0m \033[34msetup_zsh\033[0m"
echo "\033[36m(2)\033[0m \033[34msetup_swap\033[0m"
echo "\033[36m(3)\033[0m \033[34minstall_nvm\033[0m"
echo "\033[36m(4)\033[0m \033[34minstall_docker\033[0m"
echo "\033[36m(5)\033[0m \033[34mstart_docker_container\033[0m"
echo "\033[36m(6)\033[0m \033[34minstall_nginx\033[0m"
echo "\033[36m(7)\033[0m \033[34minstall_ss\033[0m"
echo "\033[36m(8)\033[0m \033[34minstall_all\033[0m"
echo "\033[36m(9)\033[0m \033[34mExit Menu\033[0m"
echo "\033[33m----------------------------------\033[0m"
read input < /dev/tty

menu()
{
    case $input in
        0)
        echo "prepare update_dep..."
        update_dep
        echo "update_dep success!"
        ;;
        1)
        # TODO 检测是否安装过
        echo "prepare setup_zsh..."
        setup_zsh
        echo "setup_zsh success!"
        menu;;
        2)
        # TODO 检测是否安装过
        echo "prepare setup_swap..."
        setup_swap
        echo "setup_swap success!"
        menu;;
        3)
        # TODO 检测是否安装过
        echo "prepare install_nvm..."
        install_nvm
        echo "install_nvm success!"
        menu;;
        4)
        # TODO 检测是否安装过
        echo "prepare install_docker..."
        install_docker
        echo "install_docker success!"
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
    input=-1
}

menu

# update_dep
# setup_zsh
# setup_swap
# install_nvm
# install_docker
# start_docker_container
# install_nginx
# install_ss
