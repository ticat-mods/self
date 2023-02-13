set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

cmd_name_path=`get_cmd_path_from_name "${1}"`
curr_dir=`get_pwd "${env}"`

repo_root=`get_repo_root_by_pwd "${curr_dir}"`
ensure_dir_in_hub "${env}" "${repo_root}"

## Make sure the old script/meta file not exists
cmd_path="${repo_root}/${cmd_name_path}"
check_cmd_files_exist_and_ensure_dir "${cmd_path}" '.go'
cmd_dir=`dirname "${cmd_path}"`

## Create the script file
rel_path=`rel_path_to_repo_root "${cmd_dir}" "${repo_root}"`
cat "${here}/templates/golang/simple.go" >> "${cmd_path}.go"
echo "[:)] '${cmd_path}.go' (cmd code file) created"

## Create the meta file
cp -f "${here}/templates/meta.simple" "${cmd_path}.go.ticat"
echo "[:)] '${cmd_path}.go.ticat' (cmd meta file) created"
