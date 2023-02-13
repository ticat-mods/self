set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

cmd_name_path=`get_cmd_path_from_name "${1}"`
curr_dir=`get_pwd "${env}"`

repo_root=`get_repo_root_by_pwd "${curr_dir}"`
ensure_dir_in_hub "${env}" "${repo_root}"

git_pull_dev_helper_lib "${repo_root}" 'python'

## Make sure the old script/meta file not exists
cmd_path="${repo_root}/${cmd_name_path}"
check_cmd_files_not_exist_and_ensure_dir "${cmd_path}" '.py'
cmd_dir=`dirname "${cmd_path}"`

## Create the script file
rel_path=`rel_path_to_repo_root "${cmd_dir}" "${repo_root}"`
echo '# -*- coding: utf-8 -*-' >> "${cmd_path}.py"
echo >> "${cmd_path}.py"
echo 'import sys' >> "${cmd_path}.py"
echo "sys.path.append('${rel_path}/helper/python.helper')" >> "${cmd_path}.py"
cat "${here}/templates/python/simple.py" >> "${cmd_path}.py"
echo "[:)] '${cmd_path}.py' (cmd script) created"

## Create the meta file
cp -f "${here}/templates/simple.meta" "${cmd_path}.py.ticat"
echo "[:)] '${cmd_path}.py.ticat' (cmd meta) created"
