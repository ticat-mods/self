. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/ticat.helper.bash/helper.bash"

function update_self()
{
	local env="${1}"

	local self_name='ticat'
	#self_name=`must_env_val "${env}" 'strs.self-name'`
	local bin_dir='bin'

	local self_path=`must_env_val "${env}" 'sys.paths.ticat'`
	local self_dir=`dirname "${self_path}"`
	local parent_dir=`dirname "${self_dir}"`

	if [ `basename "${parent_dir}"` == "${self_name}" ] && [ `basename "${self_dir}"` == "${bin_dir}" ]; then
		echo "[${self_name}] => git update"
		echo "(${parent_dir})"
		(
			cd "${parent_dir}"
			git pull
			make
		)
	else
		local update_dir="/tmp/${self_name}.self-update"
		local repo_addr="https://github.com/innerr/ticat"
		echo "[${repo_addr}] => git clone"
		echo "(${update_dir}/${self_name})"

		mkdir -p "${update_dir}"
		rm -rf "${update_dir}"/*
		(
			cd "${update_dir}"
			git clone "${repo_addr}"
			cd `basename "${repo_addr}"`
			make
			cp -f "${bin_dir}/${self_name}" "${self_path}"
		)
	fi
}
