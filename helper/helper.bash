. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/bash.helper/ticat.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/bash.helper/git.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/bash.helper/string.bash"

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
