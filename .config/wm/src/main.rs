use penrose::{
    contrib::actions::focus_or_spawn,
    core::{
        config::Config,
        helpers::{index_selectors, spawn},
        layout::{bottom_stack, monocle, side_stack, Layout, LayoutConf},
    },
    gen_keybindings, logging_error_handler, map, run_external, run_internal,
    xcb::new_xcb_backed_window_manager,
    Backward, Forward, InsertPoint, Less, More, Selector,
};

use simplelog::{LevelFilter, SimpleLogger};

const TERMINAL: &str = "alacritty";
const LAUNCHER: &str = "rofi -no-lazy-grab -show drun -modi drun";
const BROWSER: &str = "firefox";

const STARTUP_SCRIPT: &str = "/home/gokul/.config/wm/wm-startup.sh";

const MAX_MAIN: u32 = 1;
const RATIO: f32 = 0.6;

macro_rules! layout {
    { $name:expr, $func:expr } => {
        Layout::new($name, LayoutConf::default(), $func, MAX_MAIN, RATIO)
    };
    { $name:expr, $conf:expr, $func:expr } => {
        Layout::new($name, $conf, $func, MAX_MAIN, RATIO)
    };
}

fn main() -> penrose::Result<()> {
    SimpleLogger::init(LevelFilter::Info, simplelog::Config::default())
        .expect("unable to set log level");

    let floating_classes = vec![
        "rofi",
        "penrose-menu",
        "dmenu",
        "dunst",
        "pinentry-gtk-2",
        "floating",
    ];

    pub const FOLLOW_FOCUS_CONF: LayoutConf = LayoutConf {
        floating: false,
        gapless: true,
        follow_focus: true,
        allow_wrapping: true,
    };

    let config = Config::default()
        .builder()
        .workspaces(vec!["1", "2", "3", "4"])
        .floating_classes(floating_classes)
        .layouts(vec![
            layout!("[side]", side_stack),
            layout!("[botm]", bottom_stack),
            layout!("[mono]", FOLLOW_FOCUS_CONF, monocle),
        ])
        .bar_height(30)
        .gap_px(3)
        .build()
        .unwrap();

    let keybinds = gen_keybindings! {
        // Program launchers
        "M-space" => run_external!(LAUNCHER);
        "M-Return" => run_external!(TERMINAL);
        "M-b" => focus_or_spawn(BROWSER.to_string(), BROWSER.to_string());
        // Exit Penrose (important to remember this one!)
        "M-A-C-Escape" => run_internal!(exit);

        // client management
        "M-j" => run_internal!(cycle_client, Forward);
        "M-k" => run_internal!(cycle_client, Backward);
        "M-S-j" => run_internal!(drag_client, Forward);
        "M-S-k" => run_internal!(drag_client, Backward);
        "M-f" => run_internal!(toggle_client_fullscreen, &Selector::Focused);
        "M-x" => run_internal!(kill_client);

        // workspace management
        "M-Tab" => run_internal!(toggle_workspace);
        "M-A-period" => run_internal!(cycle_workspace, Forward);
        "M-A-comma" => run_internal!(cycle_workspace, Backward);

        // Layout management
        "M-grave" => run_internal!(cycle_layout, Forward);
        "M-S-grave" => run_internal!(cycle_layout, Backward);
        "M-A-k" => run_internal!(update_max_main, More);
        "M-A-j" => run_internal!(update_max_main, Less);
        "M-A-l" => run_internal!(update_main_ratio, More);
        "M-A-h" => run_internal!(update_main_ratio, Less);

        // Audio control
        "XF86AudioLowerVolume" => run_external!("amixer -D pulse sset Master 5%-");
        "XF86AudioRaiseVolume" => run_external!("amixer -D pulse sset Master 5%+");
        "XF86AudioMute" => run_external!("amixer -D pulse set Master 1+ toggle");
        "XF86AudioPlay" => run_external!("playerctl play-pause");
        "XF86AudioPrev" => run_external!("playerctl previous");
        "XF86AudioNext" => run_external!("playerctl next");

        // Screenshot
        "Print" => run_external!("bash 'maim -s | xclip -selection clipboard -t image/png'");

        // Brightness control
        "XF86MonBrightnessDown" => run_external!("light -U 5");
        "XF86MonBrightnessUp" => run_external!("light -A 5");

        refmap [ config.ws_range() ] in {
            "M-{}" => focus_workspace [ index_selectors(config.workspaces().len()) ];
            "M-S-{}" => client_to_workspace [ index_selectors(config.workspaces().len()) ];
        };
    };

    let mut wm = new_xcb_backed_window_manager(config, vec![], logging_error_handler())?;
    // Add new clients to the end of the stack
    wm.set_client_insert_point(InsertPoint::Last)?;

    spawn(STARTUP_SCRIPT)?;

    wm.grab_keys_and_run(keybinds, map! {})
}
