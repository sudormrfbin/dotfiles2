#!/usr/bin/env python3
import os
import glob
import enum
import tempfile
import subprocess
from pathlib import Path

# pip install youtube-search-python blessed
from youtubesearchpython import VideosSearch
from blessed import Terminal


def download_using_commands(args: list) -> Path:
    tmpdir = tempfile.mkdtemp(dir="/tmp/")
    os.chdir(tmpdir)
    subprocess.run(args)
    # if subprocess.run(args).returncode:
    #     raise ValueError()

    return Path(glob.glob(f"{tmpdir}/*.mp3")[0])


def download_with_spotdl(query: str) -> Path:
    return download_using_commands(["spotdl", query])


def download_with_youtube(query: str, append_audio: bool, term: Terminal):
    results = get_youtube_search(query, append_audio)
    link = select_youtube_link(results, term)
    args = f"youtube-dl -f bestaudio -x --audio-format mp3 -o '%(title)s.%(ext)s' {link}".split()

    return download_using_commands(args)


def get_youtube_search(query: str, append_audio: bool):
    results = VideosSearch(
        f"{query} audio" if append_audio else query, limit=5
    ).result()

    return [
        {
            "title": res["title"],
            "channel": res["channel"]["name"],
            "duration": res["duration"],
            "link": res["link"],
        }
        for res in results["result"]
    ]


def select_youtube_link(search_results: dict, term: Terminal) -> str:
    for i, vid in enumerate(search_results):
        print(
            "{indexcolor}{index}. {titlecolor}{title} - {channelcolor}{channel} {durationcolor}({duration})".format(
                **vid,
                index=i,
                indexcolor=term.cyan,
                titlecolor=term.olivedrab2,
                durationcolor=term.seagreen1,
                channelcolor=term.purple,
            )
        )

    print(term.normal + "Select a video: ", end="", flush=True)
    index = int(get_char(term))
    return search_results[index]["link"]


def play_audio(filename: Path, preview: bool):
    args = f"ffplay -hide_banner"
    if preview:
        args += " -ss 20 -t 5 -autoexit"
    args = args.split()
    args.append(filename)

    subprocess.run(args)


def download_and_check(
    query: str, provider: str, append_audio: bool, term: Terminal
) -> Path:
    if provider == "spotify":
        file = download_with_spotdl(query)
    elif provider == "youtube":
        file = download_with_youtube(query, append_audio, term)
    else:
        raise ValueError("invalid provider specified")

    play_audio(file, preview=True)


def get_char(term: Terminal) -> str:
    with term.cbreak():
        return term.inkey()


class State(enum.Enum):
    DOWNLOAD_AND_CHECK = 0
    FALLBACK_DOWNLOAD_AND_CHECK = 1
    INDIAN_TAGS = 2
    USER_QUERY = 3
    PICARD_TAGS = 4
    TO_TAG_OR_SEARCH = 5
    SYNCTHING = 6
    PLAY_FILE = 7


def main():
    term = Terminal()
    state = State.USER_QUERY
    files_list = []

    while True:
        if state == State.USER_QUERY:
            print("Enter query: ", end='', flush=True)
            query = input()
            state = State.DOWNLOAD_AND_CHECK

        elif state == State.DOWNLOAD_AND_CHECK:
            file = download_with_spotdl(query)
            play_audio(file, preview=True)
            state = State.TO_TAG_OR_SEARCH

        elif state == State.FALLBACK_DOWNLOAD_AND_CHECK:
            file = download_with_youtube(query, append_audio=True, term=term)
            play_audio(file, preview=False)
            state = State.TO_TAG_OR_SEARCH

        elif state == State.TO_TAG_OR_SEARCH:
            print(
                term.orange
                + "[y]tsearch, tag [i]ndian, [n]ew track, [p]icard, p[l]ay "
                + term.normal,
                end="",
                flush=True,
            )
            opt = get_char(term)
            print(opt)

            if opt not in "yl":
                files_list.append(file)

            if opt == "y":
                state = State.FALLBACK_DOWNLOAD_AND_CHECK
            elif opt == "i":
                state = State.INDIAN_TAGS
            elif opt == "n":
                state = State.USER_QUERY
            elif opt == "p":
                state = State.PICARD_TAGS
            elif opt == 'l':
                state = State.PLAY_FILE

        elif state == State.PLAY_FILE:
            play_audio(file, preview=False)
            state = State.TO_TAG_OR_SEARCH

        elif state == State.PICARD_TAGS:
            subprocess.run(["picard"] + files_list)
            state = State.SYNCTHING

        elif state == State.SYNCTHING:
            subprocess.run(["syncthing"])
            break


if __name__ == "__main__":
    main()
