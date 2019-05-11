cmus-remote -Q | python3 -c "import sys, re; print(' :', re.findall('tag title (.+)', sys.stdin.read())[0], ': ')"
