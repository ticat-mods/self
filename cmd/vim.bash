set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../helper/helper.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../helper/bash.helper/string.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/vim/helper.bash"

env=`cat "${1}/env"`
shift

cmd="${1}"
if [ -z "${cmd}" ]; then
	echo "[:(] arg 'cmd' is empty, exit" >&2
	exit 1
fi

meta='false'
if [ ! -z "${2+x}" ]; then
	meta="${2}"
	if [ "${meta}" == 'meta' ]; then
		meta='true'
	else
		meta=`to_true "${2}"`
	fi
fi

if [ "${meta}" == 'true' ]; then
	vim_path_from_api_get 'api.cmd.meta' "${cmd}" 'true'
else
	vim_path_from_api_get 'api.cmd.path' "${cmd}" 'false'
	vim_path_from_api_get 'api.cmd.meta' "${cmd}" 'true'
fi
