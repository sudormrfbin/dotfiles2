# python?, st, surf, fish, grabc

all: pipx-apps fisher emoji fzf xseticon frece
.PHONY: all

SOURCEDIR = /mnt/MyStuff/Source
PROJECTDIR =
EMOJIURL = "https://raw.githubusercontent.com/Mange/rofi-emoji/master/all_emojis.txt"
EMOJIFILE = "${HOME}/.local/share/emoji.txt"

pip:
	pip install --user -U pip

pipx:
	pip install --user -U pipx

pipx-apps: pip pipx
	pipx upgrade-all

fisher:
	fish -c "fisher self-update"
	fish -c "fisher"

emoji:
	curl ${EMOJIURL} | cut -f1,4,5 --output-delimiter ' ' > ${EMOJIFILE}
	sed -i "/skin tone/d" ${EMOJIFILE}

fzf:
	if [ ! -d ${HOME}/.fzf ]; then \
		git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf; \
	fi
	git -C ${HOME}/.fzf pull
	${HOME}/.fzf/install --bin

xseticon: PROJECTDIR = ${SOURCEDIR}/xseticon/
xseticon:
	git -C ${PROJECTDIR} pull origin master
	make -C ${PROJECTDIR} xseticon PREFIX=~/.local/ install

frece:
	fish -c "frece update --purge-old ~/.cache/yadm-files.txt (yadm ls-tree -r master --name-only | sed 's*^*/home/gokul/*' | psub)"
