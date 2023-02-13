. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/bash.helper/ticat.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/bash.helper/git.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/bash.helper/string.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/bash.helper/path.bash"

function update_self()
{
	local env="${1}"
	local download_rate_limit_token=''
	if [ ! -z "${2+x}" ]; then
		local download_rate_limit_token="${2}"
	fi

	local self_name=`must_env_val "${env}" 'strs.self-name'`
	local self_repo=`must_env_val "${env}" 'sys.self.repo'`

	# TODO: rename this to sys.paths.self
	local self_path=`must_env_val "${env}" 'sys.paths.ticat'`

	local self_dir=`dirname "${self_path}"`
	local parent_dir=`dirname "${self_dir}"`

	local bin_dir='bin'

	if [ `basename "${parent_dir}"` == "${self_name}" ] && [ `basename "${self_dir}"` == "${bin_dir}" ]; then
		echo "[${self_repo}] => git update"
		echo "(${parent_dir})"
		(
			cd "${parent_dir}"
			git pull
			make
		)
	else
		local update_path="/tmp/${self_name}.self-update"
		local downloaded=`download_bin_from_gitpage_release "${self_repo}" "${self_name}" \
			"${update_path}.download" "${download_rate_limit_token}"`

		if [ "${downloaded}" == 'true' ]; then
			cp -f "${update_path}.download/${self_name}" "${self_path}"
			rm -rf "${update_path}.download"
		else
			echo "[${self_repo}] => git clone"
			echo "(${update_path}/${self_name})"

			mkdir -p "${update_path}"
			rm -rf "${update_path}"/*
			(
				cd "${update_path}"
				git clone "${self_repo}"
				cd `basename "${self_repo}"`
				make
				cp -f "${bin_dir}/${self_name}" "${self_path}"
			)
			rm -rf "${update_path}"
		fi
	fi
}

function get_cmd_path_from_name()
{
	local name="${1}"
	if [ -z "${name}" ]; then
		echo '[:(] arg "cmd-name" is empty' >&2
		return 1
	fi
	echo "${name}" | tr '.' '/'
}

function get_repo_root_by_pwd()
{
	local curr_dir="${1}"

	local repo_root=`find_repo_root_dir "${curr_dir}"`
	if [ -z "${repo_root}" ]; then
		repo_root="${curr_dir}"
		echo "[:-] prepare to do 'git init' for current dir" >&2
		echo "     if you don't like it, remove dir '${repo_root}/.git'" >&2
		(
			cd "${repo_root}"
			echo '     ---' >&2
			git init 2>&1 | awk '{print "     [git] "$0}' >&2
		)
		echo >&2
	fi
	abs_path "${repo_root}"
}

function git_pull_dev_helper_lib()
{
	local repo_root="${1}"
	local type="${2}"
	if [ -d "${repo_root}/helper/${type}.helper" ]; then
		return 0
	fi
	(
		cd "${repo_root}"
		mkdir -p "helper"
		echo "[:-] prepare to do 'git submodule add ...' to download ${type} helper libs" >&2
		echo '     ---' >&2
		git submodule add "https://github.com/ticat-mods/${type}.helper" "helper/${type}.helper" 2>&1 |\
			awk '{print "     [git] "$0}' >&2
	)
	echo >&2
}

function check_cmd_files_exist_and_ensure_dir()
{
	local cmd_path="${1}"
	local ext="${2}"
	if [ -e "${cmd_path}.${ext}" ]; then
		echo "[:(] cmd script file '${cmd_path}.${ext}' exists, exited" >&2
		return 1
	fi
	if [ -e "${cmd_path}.${ext}.ticat" ]; then
		echo "[:(] cmd meta file '${cmd_path}.${ext}.ticat' exists, exited" >&2
		return 1
	fi

	mkdir -p `dirname "${cmd_path}"`
}
