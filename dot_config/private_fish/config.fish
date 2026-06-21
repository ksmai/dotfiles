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
    set -g fish_color_search_match white --bold --background=black
    set -g fish_color_history_current bryellow --bold

    set -g fish_pager_color_progress brwhite --bold --background=cyan
    set -g fish_pager_color_background 
    set -g fish_pager_color_prefix --bold --underline=single
    set -g fish_pager_color_completion normal
    set -g fish_pager_color_description yellow --italics
    set -g fish_pager_color_selected_background --reverse
    set -g fish_pager_color_selected_prefix 
    set -g fish_pager_color_selected_completion 
    set -g fish_pager_color_selected_description 
    set -g fish_pager_color_secondary_background 
    set -g fish_pager_color_secondary_prefix 
    set -g fish_pager_color_secondary_completion 
    set -g fish_pager_color_secondary_description 

    direnv hook fish | source
end
