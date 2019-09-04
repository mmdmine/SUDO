#!/usr/bin/fish

# Shout on fish to su commands
# Distributed under MIT, @mmdmine on github

function SUDO_update --description 'update SUDO aliases'
    echo "Updating SUDO aliases..."
    for path in $PATH
        if test -d "$path"
            for file in (/bin/ls $path)
                set shout (string upper $file)
                if test -x "$path/$file"
                    and test $file != "sudo"
                    and test $file != $shout
                    printf "Setting %s...     \r" $shout
                    alias -s $shout "sudo $file"
                end
            end
        end
    end
end

function SUDO --description 'run last command with sudo'
    eval "sudo $history[1]"
end

function SUDO_remove --description 'remove SUDO aliases and uninstall'
    function rm_fun
        set fun_path (functions -D $argv[1])
        if test -f $fun_path
            rm $fun_path
        else
            if test $fun_path != 'n/a'
                printf "can't uninstall %s, file %s doesn't exist.\n" $argv[1] $fun_path
            end
        end
    end
    function read_prompt
        echo -n "You are uninstalling SUDO aliases. Write 'YES' to confirm: "
    end
    if test (read -p read_prompt) != "YES"
        echo canceled.
        return
    end
    echo "Uninstalling, please wait..."
    rm_fun SUDO
    rm_fun SUDO_update
    rm_fun SUDO_remove
    for path in $PATH
        if test -d "$path"
            for file in (/bin/ls $path)
                set shout (string upper $file)
                if test -x "$path/$file"
                    and test $file != "sudo"
                    and test $file != $shout
                    rm_fun $shout
                end
            end
        end
    end
    echo "Uninstalled."
end

funcsave SUDO
funcsave SUDO_update
funcsave SUDO_remove

SUDO_update

echo "SUDO installed. run \'SUDO_update\' to update SUDO aliases."
