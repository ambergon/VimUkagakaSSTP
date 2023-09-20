

if !exists('g:UkagakaGhostOption')
    let g:UkagakaGhostOption = ""
endif


python3 << EOF
# -*- coding: utf-8 -*-
import vim
import socket

class VimUkagakaSSTP:

    Host    = "127.0.0.1"
    Port    = 9801

    Method      = "NOTIFY SSTP/1.5\r\n"
    Charset     = "Charset: UTF-8\r\n"
    Sender      = "Sender: vim\r\n"

    IfGhost     = ""
    Option      = ""

    End         = "\r\n"

    def __init__( self ):
        #どちらも必須オプション化。
        # = "" 空でも設定しておく必要がある。
        Ghost   = vim.vars["UkagakaGhost"].decode( encoding='utf-8') 
        Option  = vim.vars["UkagakaGhostOption"].decode( encoding='utf-8') 
        if Ghost != "":
            self.IfGhost    = "IfGhost : " + Ghost + "\r\n"
        if Option != "":
            self.Option     = "Option : " + Option + "\r\n"
        print( "set use Ghost " + Ghost )
        print( "set use Option" + Option )


    #対話用
    def Communicate( self , script ):
        Event       = "Event: OnCommunicate\r\n"
        Reference0  = "Reference0 : user\r\n"
        Reference1  = "Reference1 : " + script + "\r\n"

        msg = self.Method + self.Charset + self.Sender + self.Option + self.IfGhost + Event + Reference0 + Reference1 + self.End
        self.Send( msg )

 
    # event         = On~...
    # references    = Reference0 : .... \r\n Reference1.....
    def Func( self , event , references ):
        #print( references )
        Event       = "Event: " + event + "\r\n"
        msg = self.Method + self.Charset + self.Sender + self.Option + self.IfGhost + Event + references + self.End
        self.Send( msg )


    #カーソル化や選択範囲をテキストを投げれるようにしよう。
    def Talk( self , script ):
        Script      = "Script : " + script + "\r\n"

        msg = self.Method + self.Charset + self.Sender + self.Option + self.IfGhost + Script + self.End
        self.Send( msg )


    def Send( self , sendText ):
        Client = socket.socket( socket.AF_INET , socket.SOCK_STREAM )
        Client.connect(( self.Host , self.Port ))
        Client.send( sendText.encode() )
        response = Client.recv( 4096 )
        Client.close()



VimUkagakaSSTPInst = VimUkagakaSSTP()
EOF


"function! s:Init() abort
"    if !exists('g:loaded_VimUkagakaSSTP_pythonInit')
"        let g:loaded_VimUkagakaSSTP_pythonInit = 1
"        py3 VimUkagakaSSTPInst = VimUkagakaSSTP()
"    endif
"endfunction


"OnCommunicateを実行し引数を投げる関数。
function! VimUkagakaSSTP#Communicate( text ) abort
    execute "python3 VimUkagakaSSTPInst.Communicate('" . a:text . "')"
endfunction


"指定した関数名を実行する関数
function! VimUkagakaSSTP#Func( ... ) abort
    "let l:Func
    let l:References    = ""
    let l:Count         = 0
    for line in a:000
        if !exists( 'l:Func' )
            let l:Func = line
            continue
        endif

        let l:References = l:References . "Reference" . l:Count . " : " . line . '\r\n'
        let l:Count = l:Count + 1
    endfor

    "関数名がOnから始まらないならOnをつける。
    let l:FuncName = matchstr( l:Func , "^On.*" ) 
    if l:FuncName == ""
        let l:FuncName = "On" . l:Func
    endif
    execute "python3 VimUkagakaSSTPInst.Func('" . l:FuncName . "','" . l:References . "')"
endfunction


"選択した範囲を読み上げる関数。
function! VimUkagakaSSTP#Talk(...) abort
    let l:text =''
    for n in range(a:1, a:2)
        let l:line = getline( n )
        let l:line = substitute( l:line , "/$" , "" , "")
        let l:line = substitute( l:line , '  ' , '' , "g")
        let l:line = substitute( l:line , '\\' , '\\\\' , "g")
        let l:line = substitute( l:line , '"' , '' , "g")
        let l:line = substitute( l:line , "'" , '' , "g")
        let l:text = l:text . l:line . '\\n'
    endfor

    execute "python3 VimUkagakaSSTPInst.Talk('" . l:text . "')"
endfunction


"現在のカーソル行および、選択範囲の内容を引数とともにゴーストに渡す。
function! VimUkagakaSSTP#Ask(...) abort
    let l:text =''
    for n in range(a:2, a:3)
        let l:line = getline( n )
        let l:line = substitute( l:line , "/$" , "" , "")
        let l:line = substitute( l:line , '  ' , '' , "g")
        let l:line = substitute( l:line , '\\' , '\\\\' , "g")
        let l:line = substitute( l:line , '"' , '' , "g")
        let l:line = substitute( l:line , "'" , '' , "g")
        "let l:text = l:text . l:line 
        let l:text = l:text . l:line . '\\n'
    endfor
    let l:text = a:1 . '\\n' . l:text

    "execute "python3 VimUkagakaSSTPInst.Talk('" . l:text . "')"
    execute "python3 VimUkagakaSSTPInst.Communicate('" . l:text . "')"
endfunction






















