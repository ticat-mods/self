set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

template="${2}"
cmd_name_path=`get_cmd_path_from_name "${1}"`
curr_dir=`get_pwd "${env}"`

repo_root=`get_repo_root_by_pwd "${curr_dir}"`
ensure_dir_in_hub "${env}" "${repo_root}"

git_pull_dev_helper_lib "${repo_root}" 'bash'
cp -f "${here}/templates/bash/helper.bash" "${repo_root}/helper/"

## Make sure the old script/meta file not exists
cmd_path="${repo_root}/${cmd_name_path}"
check_cmd_files_not_exist_and_ensure_dir "${cmd_path}" ''
cmd_dir=`dirname "${cmd_path}"`

## Create the script dir
rel_path=`rel_path_to_repo_root "${cmd_dir}" "${repo_root}"`
script_path="${cmd_path}/script"
mkdir -p "${script_path}"
script_path="${cmd_path}/script/run.bash"
echo '## Exit when meet error' >> "${script_path}"
echo 'set -euo pipefail' >> "${script_path}"
echo >> "${script_path}"
echo '## Import bash helper functions for ticat' >> "${script_path}"
echo '. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/'${rel_path}'/../../helper/helper.bash"' >> "${script_path}"
cat "${here}/templates/bash/${template}.bash" >> "${script_path}"
echo "[:)] '${cmd_path}' (cmd dir and script) created"

## Create the meta file
cp -f "${here}/templates/dir/${template}.meta" "${cmd_path}.ticat"
echo "[:)] '${cmd_path}.ticat' (cmd meta) created"
