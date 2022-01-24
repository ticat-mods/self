set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

cmd="${1}"
if [ -z "${cmd}" ]; then
	echo "[:(] arg 'cmd' is empty, exit" >&2
	exit 1
fi

self=`must_env_val "${env}" 'sys.paths.ticat'`

set +e
path=`"${self}" 'api.cmd.meta' "${cmd}"`
if [ $? != 0 ]; then
	echo "[:(] get cmd path failed, wrong cmd?" >&2
	exit 1
fi
set -e
if [ ! -z "${path}" ]; then
	echo "[:)] editing ${path}"
	vim "${path}"
	exit
fi

set +e
path=`"${self}" 'api.cmd.path' "${cmd}"`
if [ $? != 0 ]; then
	echo "[:(] get cmd path failed, wrong cmd?" >&2
	exit 1
fi
set -e
if [ ! -z "${path}" ]; then
	echo "[:)] editing ${path}"
	vim "${path}"
	exit
fi
