set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
. "${here}/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

## Get cmd name
name="${1}"
if [ -z "${name}" ]; then
	echo '[:(] arg "cmd-name" is empty' >&2
	exit 1
fi
name=`echo "${name}" | tr '.' '/'`

## Get pwd
curr_dir=`get_path_under_pwd "${env}" 'dummy'`
curr_dir=`dirname "${curr_dir}"`

## Get repo root, make sure it's a repo dir
repo_root=`find_repo_root_dir "${curr_dir}"`
if [ -z "${repo_root}" ]; then
	repo_root="${curr_dir}"
	echo "[:-] prepare to do 'git init' for current dir"
	echo "     if you don't like it, remove dir '${repo_root}/.git'"
	cd "${repo_root}"
	echo '     ---'
	git init 2>&1 | awk '{print "     [git] "$0}'
	echo
fi
repo_root=`abs_path "${repo_root}"`
cd "${repo_root}"

## Make sure bash helper lib is downloaded
if [ ! -e "${repo_root}/helper/bash.helper" ]; then
	mkdir -p "helper"
	echo "[:-] prepare to do 'git submodule add ...' to download bash helper libs"
	echo '     ---'
	git submodule add https://github.com/ticat-mods/bash.helper 'helper/bash.helper' 2>&1 |\
		awk '{print "     [git] "$0}'
	cp -f "${here}/templates/bash/helper.bash" 'helper/'
	echo
fi

## Make sure the old script/meta file not exists
cmd_path="${repo_root}/${name}"
if [ -e "${cmd_path}.bash" ]; then
	echo "[:(] cmd script file '${cmd_path}.bash' exists, exited" >&2
	exit 1
fi
if [ -e "${cmd_path}.bash.ticat" ]; then
	echo "[:(] cmd meta file '${cmd_path}.bash.ticat' exists, exited" >&2
	exit 1
fi

## Create the dir
cmd_dir=`dirname "${cmd_path}"`
mkdir -p "${cmd_dir}"

## Create the script file
rel_path=`rel_path_to_repo_root "${cmd_dir}" "${repo_root}"`
echo 'set -euo pipefail' >> "${cmd_path}.bash"
echo '. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/'${rel_path}'/helper/helper.bash"' >> "${cmd_path}.bash"
cat "${here}/templates/bash/simple.bash" >> "${cmd_path}.bash"
echo "[:)] '${cmd_path}.bash' (cmd script file) created"

## Create the meta file
cp -f "${here}/templates/bash/simple.bash._ticat" "${cmd_path}.bash.ticat"
echo "[:)] '${cmd_path}.bash.ticat' (cmd meta file) created"
