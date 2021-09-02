#!/bin/bash
# Cloud Foundry CLI autocomplete script for bash

_cf_domains() {
    cf domains | awk 'NR>3{print $1}'
}

_cf_map_route() {

    local cur="${COMP_WORDS[COMP_CWORD]}"

    if [[ "2" -eq "$COMP_CWORD" ]]; then

        COMPREPLY=($(compgen -W "$domains" -- "$cur"))
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

_cf_main() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W " \
    login logout passwd help target api auth \
    apps app push scale delete rename start stop restart restage restart-app-instance \
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
    allow-space-ssh disallow-space-ssh enable-ssh disable-ssh \
    " -- "$cur"))
}

_cf() {

    cmd="${COMP_WORDS[1]}"

    if [[ "1" -eq "$COMP_CWORD" ]]; then
        _cf_main
        return
    fi

    case "$cmd" in
    create-route) _cf_create_route ;;
    map-route) _cf_map_route ;;
    *) ;; esac
}

complete -o bashdefault -F _cf cf
