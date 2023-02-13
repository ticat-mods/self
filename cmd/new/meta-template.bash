set -euo pipefail
here=`cd $(dirname ${BASH_SOURCE[0]}) && pwd`
cat "${here}/templates/meta.template"
