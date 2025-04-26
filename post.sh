#!/bin/bash

cat > /etc/skel/.gitconfig << "EOF"
[alias]
  co = checkout
  br = branch --sort=committerdate
  ci = commit
  st = status
[core]
  editor = vim
  pager = less -F -X
[credential]
  helper = cache --timeout=3600
[pull]
  ff = only
[user]
  email = you@example.com
  name = Your Name
EOF

mkdir -p /etc/skel/.bashrc.d

cat > /etc/skel/.bashrc.d/aliases << "EOF"
alias fgrep='ugrep -F -g '^tags''
alias ll='ls -lart --color=auto'
alias push='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias pull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias st='git status'
alias br='git branch'
alias log='git log'
alias log2='git log -2'
alias cherrypick='git cherry-pick'
EOF

cat > /etc/skel/.bashrc.d/bashrc << "EOF"
LANG=en_US.UTF-8
HISTSIZE=20000
HISTFILESIZE=20000
type keychain &> /dev/null && eval $(keychain -q --agents ssh --eval)
[[ -f $HOME/git-prompt.sh ]] && {
  . $HOME/git-prompt.sh
  PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
  GIT_PROMPT_ONLY_IN_REPO=1
  GIT_PS1_SHOWCOLORHINTS=1
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWUPSTREAM=auto
}
update_git_prompt() {
  rm -f $HOME/git-prompt.sh
  curl -m9 -o $HOME/git-prompt.sh 'https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh'
}
EOF

cat > /etc/skel/.vimrc << "EOF"
let mapleader=' '
set showcmd
set timeout timeoutlen=800
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set noincsearch
set hidden
set wildmode=longest:full,full
set nostartofline
set laststatus=2
set statusline=+%t%m%=%l/%L\ %P
set updatetime=1000
set nofileignorecase
set signcolumn=number
nnoremap <c-s> :update<CR>
inoremap <c-s> <c-c>:update<CR>
highlight! link SignColumn LineNr
highlight GitGutterAdd guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
let g:gitgutter_set_sign_backgrounds=1
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd='CtrlPBuffer'
let g:ctrlp_by_filename=1
let g:ctrlp_working_path_mode='c'
EOF
cp /etc/skel/.vimrc /root
