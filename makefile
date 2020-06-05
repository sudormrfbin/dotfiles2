# python?, st, surf, fish, grabc

all: fisher emoji fzf xseticon frece
.PHONY: all

SOURCEDIR = /mnt/MyStuff/Source
PROJECTDIR =
EMOJIURL = "https://raw.githubusercontent.com/Mange/rofi-emoji/master/all_emojis.txt"
EMOJIFILE = "~/.local/share/emoji.txt"
PACKAGES = git cmus dunst build-essential yadm keynav taskwarrior \
	redshift redshift-gtk j4-dmenu-desktop libterm-readkey-perl \
	fonts-noto-color-emoji sqlite3 python3-pip
PIPXPACKAGES = subliminal howdoi youtube-dlA ghstar

.ONESHELL:

install-pip:
	sudo apt upgrade python3-pip

install-pipx: pip
	pip3 install --user -U pipx

install-pipx-apps: install-pipx
	for pkg in ${PIPXPACKAGES}
	do
		pipx install $$pkg
	done
	pipx upgrade-all  # for previously installed packages

fisher:
	if ! fish -c "functions -q fisher"; then
		curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
		fish -c fisher
	fi
	fish -c "fisher self-update"
	fish -c "fisher"

emoji:
	if ! dpkg-query -W fonts-noto-color-emoji  > /dev/null 2>&1; then
		sudo apt install fonts-noto-color-emoji
	fi
	curl ${EMOJIURL} | cut -f1,4,5 --output-delimiter ' ' > ${EMOJIFILE}
	sed -i "/skin tone/d" ${EMOJIFILE}

frece-emoji: install-frece emoji
	frece update --purge-old ~/.cache/emojihist.txt ${EMOJIFILE}

install-fzf:
	if [ ! -d ~/.fzf ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	fi
	git -C ~/.fzf pull
	~/.fzf/install --bin

xseticon: PROJECTDIR = ${SOURCEDIR}/xseticon/
xseticon:
	git -C ${PROJECTDIR} pull origin master
	make -C ${PROJECTDIR} xseticon PREFIX=~/.local/ install

install-frece:
	if [ ! -e ~/.local/bin/frece ]; then
		wget -P /tmp/ https://github.com/YodaEmbedding/frece/releases/download/1.0.4/frece-1.0.4-x86_64-unknown-linux-gnu.tar.gz
		tar xf /tmp/frece-1.0.4-x86_64-unknown-linux-gnu.tar.gz \
			--strip-components=1 \
			-C ~/.local/bin \
			frece-1.0.4-x86_64-unknown-linux-gnu/frece
	fi

frece-quick-edit: install-frece
	yadm ls-tree -r master --name-only | sed 's*^*/home/gokul/*' > /tmp/yf.txt
	
	cat >> /tmp/yf.txt << EOF
	/home/gokul/gdrive/Backups/books.txt
	/home/gokul/gdrive/Backups/cringe.txt
	/home/gokul/gdrive/Backups/movies.txt
	EOF
	
	frece update --purge-old ~/.cache/yadm-files.txt /tmp/yf.txt

install-drive:
	if [ ! -e ~/.local/bin/drive ]; then
		wget -O ~/.local/bin/drive https://github.com/odeke-em/drive/releases/download/v0.3.9/drive_linux
		chmod +x ~/.local/bin/drive
		if [ ! -d ~/gdrive ]; then
			drive init ~/gdrive
			cd ~/gdrive
			drive pull
	
			mkdir -p ~/.local/share/buku
			ln -s ~/gdrive/Backups/bookmarks.db ~/.local/share/buku/bookmarks.db
		fi
	fi

install-buku:
	sudo apt install python3-certifi python3-urllib3 \
		python3-bs4 ca-certificates python3-cryptography python3-html5lib
	git clone https://github.com/jarun/buku /tmp/buku
	sudo make -C /tmp/buku install
	cp /tmp/buku/auto-completion/fish/buku.fish ~/.config/fish/completions

apt-packages:
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt install ${PACKAGES}

install-fish:
	sudo apt install build-essential cmake ncurses-dev \
		libncurses5-dev libpcre2-dev gettext
	git clone --depth=1 https://github.com/fish-shell/fish-shell /tmp/fish
	mkdir /tmp/fish/build
	cd /tmp/fish/build
	cmake ..
	make
	sudo make install
