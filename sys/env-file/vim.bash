set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

dir=`must_env_val "${env}" 'sys.paths.data'`
file=`must_env_val "${env}", 'strs.env-file-name'`

echo "[:)] ${dir}/${file} editing"
vim "${dir}/${file}"
echo "[:)] ${dir}/${file} edited"
