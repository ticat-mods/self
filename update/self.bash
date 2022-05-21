set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../helper/helper.bash"

env=`cat "${1}/env"`

echo
update_self "${env}" 'NYrOv0JuQ8iZ6cEnOTzdaTfh7ovx2Q2iwEQX'
echo
echo "self update done"
