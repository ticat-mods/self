set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

cmd_name_path=`get_cmd_path_from_name "${1}"`
curr_dir=`get_pwd "${env}"`

repo_root=`get_repo_root_by_pwd "${curr_dir}"`
ensure_dir_in_hub "${env}" "${repo_root}"

git_pull_dev_helper_lib "${repo_root}" 'bash'
cp -f "${here}/templates/bash/helper.bash" "${repo_root}/helper/"

## Make sure the old script/meta file not exists
cmd_path="${repo_root}/${cmd_name_path}"
check_cmd_files_exist_and_ensure_dir "${cmd_path}" '.bash'
cmd_dir=`dirname "${cmd_path}"`

## Create the script file
rel_path=`rel_path_to_repo_root "${cmd_dir}" "${repo_root}"`
echo 'set -euo pipefail' >> "${cmd_path}.bash"
echo '. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/'${rel_path}'/helper/helper.bash"' >> "${cmd_path}.bash"
cat "${here}/templates/bash/simple.bash" >> "${cmd_path}.bash"
echo "[:)] '${cmd_path}.bash' (cmd script file) created"

## Create the meta file
cp -f "${here}/templates/meta.simple" "${cmd_path}.bash.ticat"
echo "[:)] '${cmd_path}.bash.ticat' (cmd meta file) created"
