function pdfcat --description 'Concat pdfs matching certain filename criteria using gs'
    for ans_pdf in (find . -type f -name '*Answers.pdf' -printf '%P\n')
        set -l q_pdf (string replace ' Answers' '' "$ans_pdf")

        if not test -f "$q_pdf"
            set_color red
            echo "Question pdf for $ans_pdf not found"
            set_color normal

            continue
        end

        set -l tmpdir (mktemp -d pdfcat.XXXXX)
        set -l out_pdf "$tmpdir/out.pdf"

        gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$out_pdf" "$q_pdf" "$ans_pdf"
        mv "$out_pdf" "./$q_pdf"

        rm -r $tmpdir
        rm $ans_pdf

        set_color green
        echo "Concated $q_pdf"
        set_color normal
    end
end
