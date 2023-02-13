set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift
help_str="${2}"

cmd_name_path=`get_cmd_path_from_name "${1}"`
curr_dir=`get_pwd "${env}"`
repo_root=`get_repo_root_by_pwd "${curr_dir}"`

cmd_path="${repo_root}/${cmd_name_path}"
check_cmd_files_exist_and_ensure_dir "${cmd_path}" ''

if [ ! -z "${help_str}" ]; then
	echo "help = ${helpstr}" >> "${cmd_path}.ticat"
	echo >> "${cmd_path}.ticat"
fi

echo 'tag = config' >> "${cmd_path}.ticat"
echo >> "${cmd_path}.ticat"
echo '[val2env]' >> "${cmd_path}.ticat"
echo "${env}" | \
	{ grep -v '^strs.' || test $? = 1; } | \
	{ grep -v '^sys.' || test $? = 1; } | \
	{ grep -v '^session=' || test $? = 1; } | \
	{ grep -v '^display.' || test $? = 1; } >> "${cmd_path}.ticat"

echo "[:)] '${cmd_path}.ticat' created"
