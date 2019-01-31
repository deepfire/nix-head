#!/bin/sh

export NIX_HEAD_BASENAME="$(realpath $0 | xargs basename)"
export NIX_HEAD_ROOT="$(realpath $0 | xargs dirname)"
help_and_die() {
        cat >&2 <<EOF
${NIX_HEAD_BASENAME} CMD ARGS..

Commands:

EOF
        find ${NIX_HEAD_ROOT} -maxdepth 1 -name '[a-z]*.sh' -perm -111 | sed s,${NIX_HEAD_ROOT}/'\(.*\)\.sh,\1,' | grep -v '^head$' | sort | { read cmd; while test -n "${cmd}"; do
        printf " %20s $(grep '## Usage: ' "${NIX_HEAD_ROOT}"/${cmd}.sh | cut -c 10-)\n" "${cmd}"
        read cmd; done; } >&2; exit 1
}

while test -n "$1"
do case "$1" in
           --verbose ) set -x;;
           * ) break;;
   esac; shift; done


cmd="$1"
test -n "$cmd" || help_and_die
shift

case "${cmd}" in
         all-failures |                af  ) . "${NIX_HEAD_ROOT}"/all-failures.sh "$@";;
  all-dialog-failures | all-dialog   | ad  ) . "${NIX_HEAD_ROOT}"/all-dialog-failures.sh "$@";;
     all-raw-failures | all-raw      | ar  ) . "${NIX_HEAD_ROOT}"/all-raw-failures.sh "$@";;
                build |                b   ) . "${NIX_HEAD_ROOT}"/build.sh "$@";;
         examine-attr | examine      | e   ) . "${NIX_HEAD_ROOT}"/examine-attr.sh "$@";;
     pin-head-hackage | pin-head     | ph  ) . "${NIX_HEAD_ROOT}"/pin-head-hackage.sh "$@";;
          pin-nixpkgs |                pn  ) . "${NIX_HEAD_ROOT}"/pin-nixpkgs.sh "$@";;
          pin-package | pin          | p   ) . "${NIX_HEAD_ROOT}"/pin-package.sh "$@";;
      print-overrides | print | show       ) . "${NIX_HEAD_ROOT}"/print-overrides.sh "$@";;
            shell-for | shell        | s   ) . "${NIX_HEAD_ROOT}"/shell-for.sh "$@";;
  update-head-hackage | up-head            ) . "${NIX_HEAD_ROOT}"/update-head-hackage.sh "$@";;
       watch-failures | watch        | w   ) . "${NIX_HEAD_ROOT}"/watch-failures.sh "$@";;
        *) help_and_die;;
esac
