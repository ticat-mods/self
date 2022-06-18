set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../helper/bash.helper/helper.bash"

env=`cat "${1}/env"`
shift

session="${1}"
if [ -z "${session}" ]; then
	echo "[:(] arg 'session-id' is empty" >&2
	return 1
fi

interval="${2}"

ticat=`must_env_val "${env}" 'sys.paths.ticat'`

for ((i=0; i<9999999; i++)); do
	clear
	set +e
	"${ticat}" sessions.desc.monitor "${session}"
	set -e
	sleep "${interval}"
done
