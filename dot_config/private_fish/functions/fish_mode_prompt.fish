function fish_mode_prompt
  switch $fish_bind_mode
    case default
      set_color --bold brred
      echo '[N] '
    case insert
      set_color --bold brgreen
      echo '[I] '
    case replace_one
      set_color --bold brgreen
      echo '[R] '
    case replace
      set_color --bold brcyan
      echo '[R] '
    case visual
      set_color --bold brmagenta
      echo '[V] '
    case operator f F t T
      set_color --bold brred
      echo '[N] '
    case '*'
      set_color --bold brred
      echo '[?] '
  end
  set_color --reset
end
