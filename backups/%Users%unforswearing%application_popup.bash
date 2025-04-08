prepend_dir() { sd '^' "${1}"; } 
list_all() {
    local sysutils="/System/Applications/Utilities"
    local sysapps="/System/Applications"
    local homeapps="/Applications"
    fd . --prune -e "app" --base-directory "$sysutils" | prepend_dir "${sysutils}/" && \
    fd . --prune -e "app" --base-directory "$sysapps" | prepend_dir "${sysapps}/" && \
    fd . --prune -e "app" --base-directory "$homeapps" | prepend_dir "${homeapps}/"
}
open -a "$(
    list_all | \
    fzf --prompt="  " --color="bw,prompt:blue" --reverse --border
)"

exit
