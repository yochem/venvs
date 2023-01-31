venvs() {
	# check if XDG_DATA_HOME and venvsdir exist
	xdgdata="${XDG_DATA_HOME:-$HOME/.local/share}"
	venvsdir="$xdgdata/venvs"

	# if venvsdir is not a directory, remove the 'file' venvsdir and make dir
	if [ ! -d "$venvsdir" ]; then
		rm "$venvsdir" >/dev/null 2>&1
		mkdir "$venvsdir"
	fi

	command="$1"
	name="$2"
	shift
	shift

	case "$command" in
		'')
			source {.,}*/bin/activate >/dev/null 2>&1
			;;
		'new')
			[ -z "$name" ] && return
			if [[ "$name" = ./* ]]; then
				path="$name"
			else
				path="$venvsdir/$name"
			fi
			python3 -m venv "$path" $@ --upgrade-deps >/dev/null
			;;
		'ls'|'list')
			command ls -1 "$venvsdir"
			;;
		'rm'|'remove')
			[ -z "$name" ] && return
			if [ -z "$name" ]; then
				echo "no venv name given"
				return
			fi
			if [ ! -d "$venvsdir/$name" ]; then
				echo "no venv named $name"
				return
			fi
			command rm -rdI "$venvsdir/$name"
			;;
		'deactivate')
			deactivate
			;;
		'-h'|'--help')
			cat << END
venvs - wrapper for Python's venv

Gather all venvs in one folder and globally access them.

Global venvs directory:
$venvsdir
To move it, set \$XDG_DATA_HOME

Usage:
venvs                           activate venv in *current directory*
venvs new ./<venv> <options>    create new venv in *current directory*
                                note: run python3 -m venv --help to see options

venvs <venv>                    activate venv in the *global venvs directory*
venvs new <venv> <options>      create new venv in *global venvs directory*
                                note: run python3 -m venv --help to see options

venvs [ls | list]               list all *global* venvs
venvs [rm | remove] <venv>      remove a venv
venvs deactivate                deactivate current venv
venvs [-h | --help]             show this help
END
			;;
		*)
			if [ ! -d "$venvsdir/$command" ]; then
				echo "no venv named $command"
				return
			fi
			source "$venvsdir/$command/bin/activate"
			;;
	esac
}
