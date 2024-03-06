#!/bin/bash

SCRIPT_SKIP="1"

ffbuild_enabled() {
    [[ $TARGET == linux* ]] || [[ $TARGET == macos* ]]
}

ffbuild_dockerfinal() {
    return 0
}

ffbuild_dockerdl() {
    return 0
}

ffbuild_dockerlayer() {
    return 0
}

ffbuild_dockerstage() {
    return 0
}

ffbuild_dockerlayer_dl() {
    return 0
}

ffbuild_dockerbuild() {
    return 0
}

ffbuild_ldexeflags() {
    echo '-pie'

    if [[ $VARIANT == *shared* ]]; then
        # Can't escape escape hell
        if [[ $TARGET == macos* ]]; then
            echo -Wl,-rpath,'\\\\\\\$\\\$ORIGIN'
            echo -Wl,-rpath,'\\\\\\\$\\\$ORIGIN/../lib'
        else
            echo -Wl,-rpath='\\\\\\\$\\\$ORIGIN'
            echo -Wl,-rpath='\\\\\\\$\\\$ORIGIN/../lib'
        fi
    fi
}
