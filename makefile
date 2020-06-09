# python?, st, surf, fish, grabc

all: fisher emoji fzf xseticon frece
.PHONY: all

EMOJIURL = "https://raw.githubusercontent.com/Mange/rofi-emoji/master/all_emojis.txt"
EMOJIFILE = "~/.local/share/emoji.txt"
GH-RELEASE = ~/.local/bin/gh-release.sh
PACKAGES = git cmus dunst build-essential keynav taskwarrior \
	redshift redshift-gtk j4-dmenu-desktop libterm-readkey-perl \
	fonts-noto-color-emoji sqlite3 python3-pip ffmpeg picard \
	neomutt
PIPXPACKAGES = subliminal howdoi youtube-dl ghstar mps-youtube

BUILDDEPS =  # for target specific build (package) dependencies

.ONESHELL:

build-deps:
	if ! dpkg-query -W ${BUILDDEPS} 1> /dev/null; then
		sudo apt install ${BUILDDEPS}
	fi

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

emoji: BUILDDEPS = fonts-noto-color-emoji
emoji: build-deps
	curl ${EMOJIURL} | cut -f1,4,5 --output-delimiter ' ' > ${EMOJIFILE}
	sed -i "/skin tone/d" ${EMOJIFILE}

frece-emoji: emoji
	frece update --purge-old ~/.cache/emojihist.txt ${EMOJIFILE}

install-fzf:
	if [ ! -d ~/.fzf ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	fi
	git -C ~/.fzf pull
	~/.fzf/install --bin

install-xseticon: BUILDDEPS = libxmu-headers libgd-dev libxmu-dev libglib2.0-dev
install-xseticon: build-deps
	git clone --depth=1 https://github.com/xeyownt/xseticon /tmp/xseticon
	make -C /tmp/xseticon xseticon PREFIX=~/.local/ install

install-frece:
	curl -L $$(${GH-RELEASE} YodaEmbedding/frece linux) |
		tar xz --strip-components=1 -C ~/.local/bin

frece-quick-edit:
	yadm ls-tree -r master --name-only | sed 's*^*/home/gokul/*' > /tmp/yf.txt
	
	cat >> /tmp/yf.txt << EOF
	/home/gokul/gdrive/Backups/books.txt
	/home/gokul/gdrive/Backups/cringe.txt
	/home/gokul/gdrive/Backups/movies.txt
	EOF
	
	frece update --purge-old ~/.cache/yadm-files.txt /tmp/yf.txt

install-drive:
	curl -Lo ~/.local/bin/drive $$(${GH-RELEASE} odeke-em/drive linux)
	chmod +x ~/.local/bin/drive
	if [ ! -d ~/gdrive ]; then
		drive init ~/gdrive
		cd ~/gdrive
		drive pull
	
		mkdir -p ~/.local/share/buku
		ln -s ~/gdrive/Backups/bookmarks.db ~/.local/share/buku/bookmarks.db
	fi

install-buku: BUILDDEPS = python3-certifi python3-urllib3 \
	python3-bs4 ca-certificates python3-cryptography python3-html5lib
install-buku: build-deps
	git clone --depth=1 https://github.com/jarun/buku /tmp/buku
	sudo make -C /tmp/buku install
	cp /tmp/buku/auto-completion/fish/buku.fish ~/.config/fish/completions

apt-packages:
	sudo apt update
	sudo apt full-upgrade -y
	sudo apt install ${PACKAGES}

install-fish: BUILDDEPS = build-essential cmake ncurses-dev \
	libncurses5-dev libpcre2-dev gettext
install-fish: build-deps
	git clone --depth=1 https://github.com/fish-shell/fish-shell /tmp/fish
	mkdir /tmp/fish/build
	cd /tmp/fish/build
	cmake ..
	make
	sudo make install

fish-man-page-compls:
	fish -c 'fish_update_completions'

install-yadm:
	git clone --depth=1 https://github.com/TheLocehiliosan/yadm.git /tmp/yadm
	sudo PREFIX=/usr/local make -C /tmp/yadm install
