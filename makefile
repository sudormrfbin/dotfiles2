# python?, st, surf, fish, grabc

all: pipx-apps fisher emoji fzf xseticon frece
.PHONY: all

SOURCEDIR = /mnt/MyStuff/Source
PROJECTDIR =
EMOJIURL = "https://raw.githubusercontent.com/Mange/rofi-emoji/master/all_emojis.txt"
EMOJIFILE = "${HOME}/.local/share/emoji.txt"
PACKAGES = git cmus dunst build-essential yadm keynav taskwarrior \
	redshift redshift-gtk j4-dmenu-desktop libterm-readkey-perl \
	fonts-noto-color-emoji

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

frece-emoji:
	frece init ${HOME}/.cache/emojihist.txt ${EMOJIFILE}

install-fzf:
	if [ ! -d ${HOME}/.fzf ]; then \
		git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf; \
	fi

fzf: install-fzf
	git -C ${HOME}/.fzf pull
	${HOME}/.fzf/install --bin

xseticon: PROJECTDIR = ${SOURCEDIR}/xseticon/
xseticon:
	git -C ${PROJECTDIR} pull origin master
	make -C ${PROJECTDIR} xseticon PREFIX=~/.local/ install

frece-yadm:
	fish -c "frece update --purge-old ~/.cache/yadm-files.txt (yadm ls-tree -r master --name-only | sed 's*^*/home/gokul/*' | psub)"

install-frece:
	if [ ! -e ${HOME}/.local/bin/frece ]; then \
		wget -P /tmp/ https://github.com/YodaEmbedding/frece/releases/download/1.0.4/frece-1.0.4-x86_64-unknown-linux-gnu.tar.gz; \
		tar xf /tmp/frece-1.0.4-x86_64-unknown-linux-gnu.tar.gz \
			--strip-components=1 \
			-C ~/.local/bin \
			frece-1.0.4-x86_64-unknown-linux-gnu/frece; \
	fi

install-drive:
	if [ ! -e ${HOME}/.local/bin/drive ]; then \
		wget -O ${HOME}/.local/bin/drive https://github.com/odeke-em/drive/releases/download/v0.3.9/drive_linux; \
		chmod +x ${HOME}/.local/bin/drive; \
		if [ ! -d ${HOME}/gdrive ]; then \
			drive init ${HOME}/gdrive; \
			cd ${HOME}/gdrive; \
			drive pull; \
		fi
	fi

install-buku:
	cd /tmp; \
		git clone https://github.com/jarun/buku; \
		cd buku; \
		sudo make install; \
		cp auto-completion/fish/buku.fish ${HOME}/.config/fish/completions

apt-packages:
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt install ${PACKAGES}
