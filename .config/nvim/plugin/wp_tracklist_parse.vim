function! ReformatTrackTableWithLyricist()
    %s/"\t.\{-}\t/" /
    %s/\t/ /g
    %s/"//
    %s/"/ -/
    %s/\d:\d\d/(\0)/
endfunction

function! ReformatTrackTable()
    %s/\t/ /g
    %s/"//
    %s/"/ -/
    %s/\d:\d\d/(\0)/
endfunction
