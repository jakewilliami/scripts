#! /bin/bash

# the present script is strictly sourced after the is-os.sh script
# and requires which-pacman.sh to be sourced via jq-dep.sh
# and requires notifying-messages.sh to be sourced for pretty printing
# of messages

weNeedToSatisfyOurselves() {
    if [[ $MISSING_DEPENDENCIES == true ]]
    then
        satisfyingDeps
    fi
}


areDepsSatisfied() {
    if [[ $DEPS_DOWNLOADED == true ]]
    then
        if [[ $COUNTER_MISSING == $COUNTER_DOWNLOADED ]]
        then
            depsSatisfied
        fi
    else
        if [[ $MISSING_DEPENENCIES == true ]]
        then
            errorOccurred
            # exit 1
        fi
    fi
}


installCommand() {
    PACINSTALL=false
    
    installingPackageMessage "${1}"
    $PACMAN "${1}" && \
        PACINSTALL=true
    
    if $PACINSTALL
    then
        return 0
    else
        exit 1
    fi
}


is-command-then-install() {
    # boolean for checking if we need to install commands
    MISSING_DEPENDENCIES=false
    DEPS_DOWNLOADED=false
    COUNTER_MISSING=0
    COUNTER_DOWNLOADED=0
    
    local command
    
    # check if commands exist and update counter
    for command in "${@}"
    do
        # check for missing commands
        if ! command -v "${command}" > /dev/null 2>&1
        then
            MISSING_DEPENDENCIES=true
            COUNTER_MISSING=$((COUNTER_MISSING+1))
        fi
    done
    
    # echo dependencies if needed
    weNeedToSatisfyOurselves
    
    # install dependencies if command is not found
    for command in "${@}"
    do
        if ! command -v "${command}" > /dev/null 2>&1
        then
            installCommand "${command}" && \
                DEPS_DOWNLOADED=true
                
            if [[ $DEPS_DOWNLOADED == true ]]
            then
                COUNTER_DOWNLOADED=$((COUNTER_DOWNLOADED+1))
            fi
        fi
    done
    
    # echo if dependencies are satisfied
    areDepsSatisfied
}


is-library-then-install() {
    # compile list
    mkdir -p /tmp/package-management/
    $PACSEARCH > /tmp/package-management/pacsearch

    # boolean for checking if we need to install commands
    MISSING_DEPENDENCIES=false
    DEPS_DOWNLOADED=false
    COUNTER_MISSING=0
    COUNTER_DOWNLOADED=0

    local library

    # check for existence of library and update counter
    for library in "${@}"
    do
        if ! grep "^${library}$" /tmp/package-management/pacsearch > /dev/null 2>&1
        then
            MISSING_DEPENDENCIES=true
            COUNTER_MISSING=$((COUNTER_MISSING+1))
        fi
    done

    # echo dependencies if needed
    weNeedToSatisfyOurselves

    # install library if not found
    for library in "${@}"
    do
        if ! grep "^${library}$" /tmp/package-management/pacsearch > /dev/null 2>&1
        then
            installCommand "${library}" && \
                DEPS_DOWNLOADED=true
                
            if [[ $DEPS_DOWNLOADED == true ]]
            then
                COUNTER_DOWNLOADED=$((COUNTER_DOWNLOADED+1))
            fi
        fi
    done
    
    # echo if dependencies are satisfied
    areDepsSatisfied
}


installApplication() {
    PACINSTALL=false
    
    installingPackageMessage "${1}"
    $PACAPP "${1}" && \
        PACINSTALL=true
    
    if $PACINSTALL
    then
        return 0
    else
        exit 1
    fi
}


is-app-then-install() {
    # compile list
    mkdir -p /tmp/package-management/
    $PACSEARCH > /tmp/package-management/pacsearch
    $PACAPPSEARCH > /tmp/package-management/pacappsearch
    cat /tmp/package-management/pacsearch /tmp/package-management/pacappsearch > /tmp/package-management/pacsearch-all
    
    # boolean for checking if we need to install commands
    MISSING_DEPENDENCIES=false
    DEPS_DOWNLOADED=false
    COUNTER_MISSING=0
    COUNTER_DOWNLOADED=0
    
    local application
    
    # check for existence of library and update counter
    for application in "${@}"
    do
        if ! grep "^${application}$" /tmp/package-management/pacsearch-all > /dev/null 2>&1
        then
            MISSING_DEPENDENCIES=true
            COUNTER_MISSING=$((COUNTER_MISSING+1))
        fi
    done

    # echo dependencies if needed
    weNeedToSatisfyOurselves

    # install application if not found
    for application in "${@}"
    do
        if ! grep "^${application}$" /tmp/package-management/pacsearch-all > /dev/null 2>&1
        then
            installApplication "${application}" && \
                DEPS_DOWNLOADED=true
                
            if [[ $DEPS_DOWNLOADED == true ]]
            then
                COUNTER_DOWNLOADED=$((COUNTER_DOWNLOADED+1))
            fi
        fi
    done
}
