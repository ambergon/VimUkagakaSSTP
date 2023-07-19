"if exists('g:loaded_VimUkagakaSSTP')
"   finish
"endif
"let g:loaded_VimUkagakaSSTP = 1



command! -range             UkagakaTalk         call VimUkagakaSSTP#Talk(<line1>,<line2>)
command! -nargs=+           UkagakaFunc         call VimUkagakaSSTP#Func(<f-args>)
command! -nargs=1           UkagakaCommunicate  call VimUkagakaSSTP#Communicate(<q-args>)

command! -range -nargs=?    UkagakaAsk          call VimUkagakaSSTP#Ask(<q-args>,<line1>,<line2>)





