""sample text
"let l:word = '
"    \NOTIFY SSTP/1.5\r\n\r\n
"    \Sender: vim\r\n\r\n
"    \Event: OnTest\r\n\r\n
"    \Script: \\0This text is sent from Python.\\nCan you see this？\r\n\r\n
"    \Option: nodescript, notranslate\r\n\r\n
"    \Charset: UTF-8\r\n\r\n
"    \\r\n\r\n'

let s:NOTIFY    = 'NOTIFY SSTP/1.5\r\n\r\n'
let s:SENDER    = 'Sender: VimUkagakaSSTP\r\n\r\n'
"let s:EVENT or SCRIPT = add your text Script or Event
let s:OPTION    = 'Option: nodescript, notranslate\r\n\r\n'
let s:CHARSET   = 'Charset: UTF-8\r\n\r\n'
let s:END       = '\r\n\r\n'


function! VimUkagakaSSTP#Func( ... ) abort
    let l:reference = ""
    let l:count = 0
    for line in a:000
        "関数名を排除
        if !exists( 'l:first' )
            let l:first = "done"
            continue
        endif

        let l:reference = l:reference . "reference" . l:count . ": " . line . '\r\n\r\n'
        let l:count = l:count + 1
    endfor

    "matchstr(検索対象,検索テキスト) 
    let l:FuncName = matchstr( a:1 , "^On.*" ) 
    if l:FuncName == ""
        let l:FuncName = "On" . a:1
    endif
    let l:FuncName      = "Event: " . l:FuncName . '\r\n\r\n'
    let l:script    = "SCRIPT: I dont load " . l:FuncName . ' function\r\n\r\n' 
    let l:text      = s:NOTIFY . s:SENDER . l:FuncName . l:reference . l:script . s:OPTION . s:CHARSET . s:END
    execute "python3 VimUkagakaSSTPInst.talk('" . l:text . "')"
endfunction


function! VimUkagakaSSTP#Talk(...) abort
    let l:text =''
    for n in range(a:1, a:2)
        let l:line = getline( n )
        let l:line = substitute( l:line , "/$" , "" , "")
        let l:line = substitute( l:line , '  ' , '' , "g")
        let l:line = substitute( l:line , '\\' , '\\\\' , "g")
        let l:line = substitute( l:line , '"' , '' , "g")
        let l:line = substitute( l:line , "'" , '' , "g")
        let l:text = l:text . l:line
    endfor
    let l:text = "SCRIPT: " . l:text . '\r\n\r\n'
    let l:text      = s:NOTIFY . s:SENDER . l:text . s:OPTION . s:CHARSET . s:END
    execute "python3 VimUkagakaSSTPInst.talk('" . l:text . "')"
endfunction


python3 << EOF
# -*- coding: utf-8 -*-
#vim からpythonに投げる際に改行コードの数を確認すること。
import vim
import socket

class VimUkagakaSSTP:
    test = ""

    def __init__(self):
        self.test = ""

    def talk( self , word ):
        #print(word)
        #print(word.encode())
        host = "127.0.0.1"
        port = 9801

        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client.connect((host, port))

        client.send(word.encode())
        response = client.recv(4096)
        client.close()
        #print(response.decode())

VimUkagakaSSTPInst = VimUkagakaSSTP()
EOF
