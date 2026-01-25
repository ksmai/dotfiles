#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# export GLFW_IM_MODULE=ibus
# export GTK_IM_MODULE=ibus
# export QT_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
export XMODIFIERS=@im=fcitx
export EDITOR=nvim
export FZF_DEFAULT_COMMAND='rg --files --hidden --iglob !.git/'
