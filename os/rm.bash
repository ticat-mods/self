set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../helper/helper.bash"

shift

target="${1}"
if [ -z "${target}" ]; then
	echo "[:(] arg 'target' is empty, exit" >&2
	exit 1
fi
if [ "${target}" == '/' ] || [ "${target}" == '\' ]; then
	echo "[:(] cat't remove root dir, exit" >&2
	exit 1
fi

force=`to_true "${2}"`
if [ "${force}" == 'true' ]; then
	force=' -f'
fi

recursive=`to_true "${3}"`
if [ "${recursive}" == 'true' ]; then
	recursive=' -r'
fi

rm${force}${recursive} "${target}"
