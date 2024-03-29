#!/bin/bash
# Cloud Foundry CLI autocomplete script for bash

_deleteLocalCache() {
    rm -rf ~/cf.cache/*

    printf "\nCache cleared"
}

_loadCache() {
    local command=$1

    cat ~/cf.cache/"$command" 2>/dev/null
}

_saveCache() {
    local command=$1
    local value=$2

    echo "$value" >~/cf.cache/"$command"
}

_execWithCache() {
    local cacheName=$1
    local command=$2
    local value

    value=$(_loadCache "$cacheName")

    if [[ -z "$value" ]]; then
        value=$(eval "$command")
        _saveCache "$cacheName" "$value"
    fi

    echo "$value"
}

_cf_domains() {
    _execWithCache 'domains' $'cf domains | awk \'NR>3{print $1}\''
}

_cf_apps() {
    _execWithCache 'apps' $'cf apps | awk \'NR>3{print $1}\''
}

_cf_services() {
    _execWithCache 'services' $'cf services | awk \'NR>3{print $1}\''
}

_cf_hostnames() {
    _execWithCache 'hostnames' $'cf routes | awk \'NR>3{print $2}\''
}

_cf_mtas() {
    _execWithCache 'mtas' $'cf mtas | awk \'NR>3{print $1}\''
}

_cf_mta_archives() {
    find . -iname "*.mtar"
    echo "-i"
}

_cf_json_files() {
    find . -maxdepth 2 -iname "*.json"
}

_cf_available_services() {
    _execWithCache 'available_services' $'cf marketplace | awk \'NR>3{print $1}\''
}

_cf_available_service_plans() {
    local service=$1
    local cacheName="service_plans_$service"
    local command="cf marketplace -e $service | awk 'NR>4{print \$1}'"

    _execWithCache "$cacheName" "$command"
}

_cf_mta_operations() {
    cf mta-ops | awk 'NR>3{print $1}'
}

_cf_spaces() {
    _execWithCache 'spaces' $'cf spaces | awk \'NR>3{print $1}\''
}

_scale() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--process" -- "$cur"))
        return
    fi

    if [[ "4" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "web" -- "$cur"))
        return
    fi

    if [[ "5" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "-i" -- "$cur"))
        return
    fi

    if [[ "7" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "-m" -- "$cur"))
        return
    fi

    if [[ "8" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "128M 256M 384M 512M 784M 1024M" -- "$cur"))
        return
    fi

}

_logs() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--recent" -- "$cur"))
        return
    fi

}

_app() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

}

_ssh() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "-L" -- "$cur"))
        return
    fi

    if [[ "4" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "9229:localhost:9229" -- "$cur"))
        return
    fi

}

_create_app_manifest() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "-p" -- "$cur"))
        return
    fi

    if [[ "4" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "manifest.yaml" -- "$cur"))
        return
    fi

}

_cf_map_route() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_domains)" -- "$cur"))
        return
    fi

    if [[ "4" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--hostname" -- "$cur"))
        return
    fi

    if [[ "5" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_hostnames)" -- "$cur"))
        return
    fi

    if [[ "6" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--path" -- "$cur"))
        return
    fi

}

_cf_create_route() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_domains)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--hostname" -- "$cur"))
        return
    fi

    if [[ "5" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--path" -- "$cur"))
        return
    fi

}

_cf_delete_route() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_domains)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--hostname" -- "$cur"))
        return
    fi

    if [[ "4" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_hostnames)" -- "$cur"))
        return
    fi

}

_bind-service() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_services)" -- "$cur"))
        return
    fi

}

_unbind-service() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_apps)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_services)" -- "$cur"))
        return
    fi

}

_service() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_services)" -- "$cur"))
        return
    fi

}

_create-service() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_available_services)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_available_service_plans "${COMP_WORDS[2]}")" -- "$cur"))
        return
    fi

    if [[ "5" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "-c" -- "$cur"))
        return
    fi

    if [[ "6" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_json_files)" -- "$cur"))
        return
    fi

}

_update-service() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_services)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "-c" -- "$cur"))
        return
    fi

}

_delete-service() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_services)" -- "$cur"))
        return
    fi

}

_mta() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_mtas)" -- "$cur"))
        return
    fi

}

_deploy() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_mta_archives)" -- "$cur"))
        return
    fi

    if [[ "-i" = "${COMP_WORDS[2]}" ]]; then
        _deploy_actions
        return
    fi

    _deploy_deploy

}

_deploy_deploy() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_mta_archives)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--strategy" -- "$cur"))
        return
    fi

    if [[ "4" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "blue-green" -- "$cur"))
        return
    fi

    if [[ "5" -eq "$COMP_CWORD" ]]; then

        COMPREPLY=($(compgen -W "--skip-testing-phase --skip-idle-start" -- "$cur"))
        return
    fi

    if [[ "6" -eq "$COMP_CWORD" ]]; then

        if [[ "--skip-testing-phase" = "${COMP_WORDS[5]}" ]]; then
            OPTIONS="--skip-idle-start"
        else
            OPTIONS="--skip-testing-phase"
        fi

        COMPREPLY=($(compgen -W "$OPTIONS" -- "$cur"))
        return
    fi

}

_deploy_actions() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_mta_operations)" -- "$cur"))
        return
    fi

    if [[ "4" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "-a" -- "$cur"))
        return
    fi

    if [[ "5" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "abort retry resume monitor" -- "$cur"))
        return
    fi

}

_undeploy() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_mtas)" -- "$cur"))
        return
    fi

    if [[ "3" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--delete-services" -- "$cur"))
        return
    fi

}

_service-manager-service-instances() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "--credentials" -- "$cur"))
        return
    fi

}

_cf_delete_space() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then
        COMPREPLY=($(compgen -W "$(_cf_spaces)" -- "$cur"))
        return
    fi

}
_cf_main() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W " \
    login logout passwd help target api auth \
    apps app push scale delete rename start stop restart restage restart-app-instance droplets download-droplet\
    events files logs env set-env unset-env stacks \
    stack copy-source create-app-manifest marketplace services service create-service \
    update-service rename-service delete-service \
    create-service-key service-keys service-key delete-service-key bind-service unbind-service \
    create-user-provided-service update-user-provided-service \
    orgs org create-org delete-org \
    spaces space create-space delete-space space-users set-space-role unset-space-role \
    domains create-domain delete-domain create-shared-domain delete-shared-domain \
    routes create-route check-route map-route unmap-route delete-route delete-orphaned-routes \
    buildpacks create-buildpack update-buildpack rename-buildpack delete-buildpack \
    running-environment-variable-group staging-environment-variable-group set-staging-environment-variable-group set-running-environment-variable-group \
    feature-flags feature-flag enable-feature-flag disable-feature-flag \
    curl config oauth-token \
    add-plugin-repo remove-plugin-repo list-plugin-repos repo-plugins plugins install-plugin uninstall-plugin \
    targets save-target set-target delete-target \
    allow-space-ssh disallow-space-ssh enable-ssh disable-ssh ssh \
    delete-autocomplete-cache \
    service-manager-service-instances \
    mta mtas mta-ops \
    deploy undeploy
    " -- "$cur"))
}

_cf() {

    if [[ ! -d ~/cf.cache ]]; then
        mkdir ~/cf.cache
    fi

    cmd="${COMP_WORDS[1]}"

    if [[ "1" -eq "$COMP_CWORD" ]]; then
        _cf_main
        return
    fi

    case "$cmd" in
    create-route) _cf_create_route ;;
    delete-route) _cf_delete_route ;;
    map-route) _cf_map_route ;;

    create-app-manifest) _create_app_manifest ;;
    push) _app ;;
    start) _app ;;
    stop) _app ;;
    restart) _app ;;
    restage) _app ;;
    app) _app ;;
    env) _app ;;
    logs) _logs ;;
    scale) _scale ;;
    delete) _app ;;
    set-env) _app ;;
    droplets) _app ;;
    download-droplet) _app ;;
    bind-service) _bind-service ;;
    unbind-service) _unbind-service ;;

    service) _service ;;
    service-key) _service ;;
    service-keys) _service ;;

    create-service) _create-service ;;
    update-service) _update-service ;;
    delete-service) _delete-service ;;

    ssh) _ssh ;;
    enable-ssh) _app ;;
    disable-ssh) _app ;;

    mta) _mta ;;

    deploy) _deploy ;;
    undeploy) _undeploy ;;

    delete-space) _cf_delete_space ;;

    service-manager-service-instances) _service-manager-service-instances ;;

    delete-autocomplete-cache) _deleteLocalCache ;;
    *) ;; esac
}

complete -o bashdefault -F _cf cf
