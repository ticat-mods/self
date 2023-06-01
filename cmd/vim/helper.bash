function vim_path_from_api_get()
{
	local key="${1}"
	local cmd="${2}"
	local err_when_not_found=`to_true "${3}"`
	local editor="${4}"

	local self=`must_env_val "${env}" 'sys.paths.ticat'`

	set +e
	local path=`"${self}" "${key}" "${cmd}"`
	if [ $? != 0 ]; then
		echo "[:(] get cmd path failed, wrong cmd?" >&2
		exit 1
	fi
	set -e

	if [ -z "${path}" ]; then
		if [ "${err_when_not_found}" == 'true' ]; then
			echo "[:(] cmd script/meta file not found, wrong cmd or builtin cmd?" >&2
			exit 1
		else
			return 0
		fi
	fi

	local lines=`echo "${path}" | wc -l | awk '{print $1}'`
	if [ "${lines}" != 1 ]; then
		echo "[:(] get cmd path failed, too many result lines:" >&2
		echo '***' >&2
		echo "${path}" >&2
		echo '***' >&2
		exit 1
	fi
	echo "[:)] ${path} editing"
	"${editor}" "${path}"
	echo "[:)] ${path} edited"
	exit
}
