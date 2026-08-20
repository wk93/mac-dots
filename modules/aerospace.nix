{pkgs, ...}: {
  services.aerospace = {
    enable = true;
    package = pkgs.aerospace;
    settings = {
      # brak gapsów — flush jak sway (border 0, titlebar false)
      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer.left = 0;
        outer.right = 0;
        outer.top = 0;
        outer.bottom = 0;
      };

      # assign aplikacji do workspace (odpowiednik sway `assigns`)
      on-window-detected = [
        {
          "if".app-id = "com.mitchellh.ghostty";
          run = "move-node-to-workspace 1";
        }
        {
          "if".app-id = "com.brave.Browser";
          run = "move-node-to-workspace 2";
        }
      ];

      mode.main.binding = {
        # --- workspaces 1..9 (Super = ctrl+alt = lewy Option) ---
        "ctrl-alt-1" = "workspace 1";
        "ctrl-alt-2" = "workspace 2";
        "ctrl-alt-3" = "workspace 3";
        "ctrl-alt-4" = "workspace 4";
        "ctrl-alt-5" = "workspace 5";
        "ctrl-alt-6" = "workspace 6";
        "ctrl-alt-7" = "workspace 7";
        "ctrl-alt-8" = "workspace 8";
        "ctrl-alt-9" = "workspace 9";

        # --- przenieś okno do ws + podążaj (jak sway move+focus) ---
        "ctrl-alt-shift-1" = ["move-node-to-workspace 1" "workspace 1"];
        "ctrl-alt-shift-2" = ["move-node-to-workspace 2" "workspace 2"];
        "ctrl-alt-shift-3" = ["move-node-to-workspace 3" "workspace 3"];
        "ctrl-alt-shift-4" = ["move-node-to-workspace 4" "workspace 4"];
        "ctrl-alt-shift-5" = ["move-node-to-workspace 5" "workspace 5"];
        "ctrl-alt-shift-6" = ["move-node-to-workspace 6" "workspace 6"];
        "ctrl-alt-shift-7" = ["move-node-to-workspace 7" "workspace 7"];
        "ctrl-alt-shift-8" = ["move-node-to-workspace 8" "workspace 8"];
        "ctrl-alt-shift-9" = ["move-node-to-workspace 9" "workspace 9"];

        # --- launch apps ---
        "ctrl-alt-enter" = "exec-and-forget open -a Ghostty";
        "ctrl-alt-b" = "exec-and-forget open -a 'Brave Browser'";
        "ctrl-alt-p" = "exec-and-forget open -a '1Password'";
        "ctrl-alt-q" = "close";

        # --- focus (i3-style, umożliwione przez ctrl+alt bez kolizji z ł) ---
        "ctrl-alt-h" = "focus left";
        "ctrl-alt-j" = "focus down";
        "ctrl-alt-k" = "focus up";
        "ctrl-alt-l" = "focus right";

        # --- move okna w layoucie ---
        "ctrl-alt-shift-h" = "move left";
        "ctrl-alt-shift-j" = "move down";
        "ctrl-alt-shift-k" = "move up";
        "ctrl-alt-shift-l" = "move right";
      };
    };
  };
}
