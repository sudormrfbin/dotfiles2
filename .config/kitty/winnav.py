from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: list[str]):
    pass


def normalize_dir(dir: str) -> str:
    # the config file accepts up and down but internally kitty
    # uses top and bottom
    # https://github.com/kovidgoyal/kitty/blob/902b9e9693c9b2d8f3e9738aa4978dfa7fd9b87d/kitty/options/utils.py#L214
    return {"up": "top", "down": "bottom"}.get(dir, dir)


@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    tab = boss.active_tab
    direction: str = normalize_dir(args[1])
    if tab.neighboring_group_id(direction):
        tab.neighboring_window(direction)
    else:
        raise Exception(f"No window in specified direction '{direction}'")
