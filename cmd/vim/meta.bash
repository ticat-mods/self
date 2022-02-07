set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../../helper/helper.bash"
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/helper.bash"

env=`cat "${1}/env"`
shift

cmd="${1}"
if [ -z "${cmd}" ]; then
	echo "[:(] arg 'cmd' is empty, exit" >&2
	exit 1
fi

vim_path_from_api_get 'api.cmd.meta' "${cmd}" 'false'
vim_path_from_api_get 'api.cmd.path' "${cmd}" 'true'
