set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../../helper/helper.bash"

env=`cat "${1}/env"`

dir=`must_env_val "${env}" 'sys.paths.data.shared'`

echo rm -rf "${dir}/*"
rm -rf "${dir}"/*
