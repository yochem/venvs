function venvs
	set -q $XDG_DATA_HOME; or set XDG_DATA_HOME "$HOME/.local/share"
	set venvsdir "$XDG_DATA_HOME/venvs"
	not [ -d "$venvsdir" ] && rm "$venvsdir" 2>/dev/null 2>&1 && mkdir "$venvsdir"

	set command "$argv[1]"
	set name "$argv[2]"

	switch "$command"
		case ''
			source (fd --max-depth 3 activate.fish)
		case 'new'
			[ -z "$name" ] && return
			if string match -q './*' $name
				set path $name
			else
				set path "$venvsdir/$name"
			end
			python3 -m venv "$path" $argv[3..]
		case 'l*s*' # matches ls and list
			command ls "$venvsdir"
		case 'r*m*' # matches rm and remove
			[ -z "$name" ] && return
			not [ -d "$venvsdir/$name" ] && echo "no venv named $name" && return
			command rm -rdI "$venvsdir/$name"
		case 'deactivate'
			deactivate
		case '-*h***' # matches -h and --help
			echo "\
venvs - wrapper for Python's venv

Gather all venvs in one folder and globally access them.

Global venvs directory:
$venvsdir
To move it, set \$XDG_DATA_HOME

Usage:
venvs                        activate venv in *current directory*
venvs new ./<venv> <options> create new venv in *current directory*
                             note: run python3 -m venv --help to see options

venvs <venv>                 activate venv in the *global venvs directory*
venvs new <venv> <options>   create new venv in *global venvs directory*
                             note: run python3 -m venv --help to see options

venvs [ls | list]            list all venvs
venvs [rm | remove] <venv>   remove a venv
venvs deactivate             deactivate current venv
venvs [-h | --help]          show this help"
		case '*'
			not [ -d "$venvsdir/$command" ] && echo "no venv named $command" && return
			source "$venvsdir/$command/bin/activate.fish"
	end
end
