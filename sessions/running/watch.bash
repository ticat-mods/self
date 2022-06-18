set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../../helper/bash.helper/helper.bash"

env=`cat "${1}/env"`
interval="${2}"

ticat=`must_env_val "${env}" 'sys.paths.ticat'`

for ((i=0; i<9999999; i++)); do
	clear
	set +e
	"${ticat}" sessions.running.desc.monitor
	set -e
	sleep "${interval}"
done
