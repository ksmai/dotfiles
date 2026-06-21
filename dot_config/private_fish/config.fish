if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings

    set -g fish_color_normal white
    set -g fish_color_command brgreen --bold 
    set -g fish_color_keyword brred
    set -g fish_color_quote bryellow
    set -g fish_color_redirection brcyan --bold
    set -g fish_color_end fe8019
    set -g fish_color_error brred --underline=curly
    set -g fish_color_param white
    set -g fish_color_valid_path white --underline=single
    set -g fish_color_option brblue
    set -g fish_color_comment brblack
    set -g fish_color_selection white --bold --background=black
    set -g fish_color_operator white
    set -g fish_color_escape fe8019
    set -g fish_color_autosuggestion brblack
    set -g fish_color_cwd brgreen
    set -g fish_color_cwd_root brred
    set -g fish_color_user brgreen
    set -g fish_color_host bryellow
    set -g fish_color_host_remote bryellow
    set -g fish_color_status brred
    set -g fish_color_cancel white
    set -g fish_color_search_match --reset
    set -g fish_color_history_current bryellow --bold

    set -g fish_pager_color_progress 282828 --bold --background=a89984
    set -g fish_pager_color_background 
    set -g fish_pager_color_prefix white --bold --underline=single
    set -g fish_pager_color_completion white
    set -g fish_pager_color_description fe8019
    set -g fish_pager_color_selected_background --background=brblue
    set -g fish_pager_color_selected_prefix 504945 --bold --underline=single
    set -g fish_pager_color_selected_completion 504945 --bold
    set -g fish_pager_color_selected_description 504945 --bold
    set -g fish_pager_color_secondary_background 
    set -g fish_pager_color_secondary_prefix 
    set -g fish_pager_color_secondary_completion 
    set -g fish_pager_color_secondary_description 

    direnv hook fish | source
end
