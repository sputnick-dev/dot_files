" local syntax file - set colors on a per-machine basis:
" Vim color file
" Maintainer:	sputnick"
" Last Change:	20100201
" Color_Sheme: base on a sputnick + work's Ron Aaron <ronaharon@yahoo.com>

"Now that Konsole 3.5.4 with 256 colors support has hit Debian testing,
"I got to try 256 color mode in terminal mode.
"To enable it, put in your .vimrc, before setting the colorscheme:
"set t_Co=256 

"various help on /usr/share/vim/vim-current/doc/syntax.vim, line 210
"il est preferable d'avoir la valeur none en majuscule evitant les erreurs
"dans la gui


hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "sputnick"

"set guifont=Monosputnick\ 12
"set guifont=Terminus\ 8
set guifont=Monospace\ 11

" term utilisé
if &term=~ "xterm"
    set term=xterm-256color
endif
" jeu de couleurs standard
if &term=~ "linux"
    colorscheme default
else
    colorscheme sputnick
endif

"TERM
hi Comment      term=bold
hi Constant     term=underline
hi Identifier   term=underline
hi Search       term=reverse
hi Special      term=bold
hi Statement    term=bold
hi Error        term=reverse
hi Todo         term=standout
hi Directory    term=bold
hi ErrorMsg     term=standout
hi IncSearch    term=reverse
hi LineNr       term=underline
hi ModeMsg      term=bold
hi MoreMsg      term=bold
hi NonText      term=bold
hi Question     term=standout
hi SpecialKey   term=bold
hi StatusLine   term=reverse,bold
hi Title        term=bold
hi WarningMsg   term=standout
hi Visual       term=reverse

"256 COLORS TERM
" darker hi Comment			ctermfg=59
" voir vars pablo = bleu
hi Comment			ctermfg=239
" constantes ctermfg=253 = gris clair
hi Constant			ctermfg=15
hi Cursor			ctermfg=0	ctermbg=40
hi CursorLine	cterm=NONE	ctermfg=1	ctermbg=1
hi Directory			ctermfg=11
hi Error			ctermfg=15	ctermbg=124
hi ErrorMsg			ctermfg=15	ctermbg=9
" nom des functions(){ } en bash ( marche pas en perl )
hi Function			ctermfg=202
" meilleures couleures retenues :
" 4 12 24 29 30 32 66 101 103 104 135 141 146 147 165 208
" for ((i=0; i<256; i++ )); do echo 'ctermfg=$i'; sed -i -r '73{s/ctermfg=[0-9]+/ctermfg=$i/}' /usr/share/vim/vim72/colors/sputnick.vim; read -n1 -s; done
"hi Identifier			ctermfg=4 guifg=SeaGreen
"hi Identifier			ctermfg=24 guifg=SeaGreen
"hi Identifier			ctermfg=29 guifg=SeaGreen
"hi Identifier			ctermfg=30 guifg=SeaGreen
"hi Identifier			ctermfg=104 guifg=SeaGreen
"hi Identifier		ctermfg=135 guifg=SeaGreen
"hi Identifier			   ctermfg=66 guifg=SeaGreen
"variables :
hi Identifier			ctermfg=147 guifg=SeaGreen
hi Ignore			ctermfg=235
hi IncSearch			ctermfg=9	ctermbg=11
hi LineNr			ctermfg=11
hi ModeMsg	cterm=BOLD
hi MoreMsg	cterm=BOLD      ctermfg=29
hi NonText	cterm=BOLD      ctermfg=214
" commande basique
hi Normal			ctermfg=46	ctermbg=16
hi PreProc			ctermfg=117
hi Question	cterm=BOLD      ctermfg=14
hi Repeat			ctermfg=226
hi Search			ctermfg=15	ctermbg=28
hi Special			ctermfg=203
hi SpecialKey			ctermfg=14
hi Statement			ctermfg=227	
" ligne du bas ( nom de fichier position )
hi StatusLine			ctermfg=252     ctermbg=202
hi StatusLineN			ctermfg=15      ctermbg=203
hi Title	cterm=BOLD      ctermfg=214
hi Todo				ctermfg=11	ctermbg=19
hi Type			    	ctermfg=214	
hi Underlined	cterm=underline ctermfg=NONE
hi Visual			ctermfg=1      ctermbg=202
hi WarningMsg			ctermfg=9       ctermbg=15

"GUI
hi Comment			guifg=#9a8576
hi Constant	gui=NONE	guifg=#f0f0f0	
hi Cursor			guifg=#000000	guibg=#00e600
hi CursorLine	gui=NONE	guifg=NONE	guibg=#080808
hi Directory			guifg=#ffff00
hi Error			guifg=#ffffff	guibg=#af0000
hi ErrorMsg			guifg=#ffffff	guibg=#ff0000
hi Function			guifg=#af5fff
hi Identifier			guifg=#ff66fd
hi Ignore			guifg=#262626
hi IncSearch			guifg=#ff0000	guibg=#ffff00
hi LineNr			guifg=#ffff00
hi ModeMsg	gui=BOLD
hi MoreMsg	gui=BOLD	guifg=SeaGreen
hi NonText	gui=BOLD	guifg=orange
hi Normal			guifg=#00e600	guibg=#111111			
hi PreProc			guifg=#80eeff
hi Question	gui=BOLD	guifg=Cyan
hi Repeat			guifg=#ffff00
hi Search			guifg=#ffffff	guibg=#009600
hi Special			guifg=#ff4040
hi SpecialKey			guifg=Cyan
hi Statement	gui=NONE	guifg=#ffff50	
hi StatusLine	gui=NONE	guifg=#d0d0d0	guibg=#404040
hi StatusLineN	gui=NONE	guifg=#ffffff	guibg=#ff3333
hi Title	gui=BOLD	guifg=Orange
hi Todo				guifg=#ffff00	guibg=#0000af
hi Type		gui=NONE	guifg=#ffb400	
hi Underlined	gui=underline	guifg=NONE
hi Visual	gui=NONE	guifg=#ffffff	guibg=darkgreen
hi WarningMsg			guifg=#ff0000	guibg=#ffffff

if version >= 700
    au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
    au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
endif
