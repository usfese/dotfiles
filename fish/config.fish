if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting ""
set -p PATH ~/.local/bin ~/.npm-global/bin
starship init fish | source
zoxide init fish --cmd cd | source

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function cat
    command bat $argv
end

function ls
    command eza --icons $argv
end
function lt
    command eza --icons --tree $argv
end

# grub
abbr grub 'LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 sudo grub-mkconfig -o /boot/grub/grub.cfg'
# 小黄鸭补帧 需要steam安装正版小黄鸭
abbr lsfg 'LSFG_PROCESS="miyu"'
# fa运行fastfetch
abbr fa fastfetch
abbr reboot 'systemctl reboot'
function sl
    command sl | lolcat
end
function 滚
    sysup
end
function raw
    command ~/.config/scripts/random-anime-wallpaper.sh $argv
end

function 安装
    command yay -S $argv
end

function 卸载
    command yay -Rns $argv
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/shorin/.lmstudio/bin
# End of LM Studio CLI section

# 设置代理服务器地址
# set -g proxy_url "http://127.0.0.1:7890"
#
# # 定义开启代理的函数
# function proxy_on
#     set -gx http_proxy $proxy_url
#     set -gx https_proxy $proxy_url
#     set -gx ftp_proxy $proxy_url
#     set -gx all_proxy $proxy_url
#     set -gx HTTP_PROXY $proxy_url
#     set -gx HTTPS_PROXY $proxy_url
#     set -gx FTP_PROXY $proxy_url
#     set -gx ALL_PROXY $proxy_url
# end
#
# # 定义关闭代理的函数
# function proxy_off
#     set -e http_proxy
#     set -e https_proxy
#     set -e ftp_proxy
#     set -e all_proxy
#     set -e HTTP_PROXY
#     set -e HTTPS_PROXY
#     set -e FTP_PROXY
#     set -e ALL_PROXY
# end
#
# # 如果你希望【打开终端默认就启动代理】，取消下面这一行的注释：
# proxy_on

# Neovim全屏
function nvim
    # 1. 启动 nvim 前，通知 niri 最大化当前列
    niri msg action maximize-column

    # 2. 运行真正的 nvim
    command nvim $argv

    # 3. 退出 nvim 后，再次触发该动作以恢复原样
    niri msg action maximize-column
end
