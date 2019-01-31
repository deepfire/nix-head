#!/bin/sh
## Usage:                  `all-failures` with a dialog UI for failed drvs

nhroot=$(dirname $0)
nix-shell -p dialog --command \
          "${nhroot}/all-failures.sh 2>/dev/null | \
           xargs echo | \
           { read xs; \
             if test -n \"\$xs\"; \
             then tmpf=\$(mktemp); \
                  while { dialog --no-items --menu 'Logs of failed derivations:' 0 0 0 \$xs 2>\$tmpf; \
                          if test \${PIPESTATUS[0]} = 0; then cat \$tmpf | xargs nix log | less --clear-screen; else return 1; fi; }; \
                  do true; done; \
             else echo \"Utena:  Let's have tea and laugh together ten years from now, okay? Promise?\"; \
             fi; }"
