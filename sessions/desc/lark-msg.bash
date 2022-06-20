set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

ticat=`must_env_val "${env}" 'sys.paths.ticat'`
session=`must_env_val "${env}" 'sys.session.id'`
url=`must_env_val "${env}" 'lark.secret.notify-url'`

set +e
msg=`"${ticat}" {sys.session.disable=true} display.quiet : display.tips.off : display.plain : \
	echo "[${session}] - [[sys.session.id.ip]]" : sessions.desc "${session}" 2>&1`
set -e

if [ -z "${msg}" ]; then
	msg="can't get info from session '${session}'"
fi

# This maybe not right under MacOS
msg=`echo "${msg}" | sed '$!s/$/\\\n/' | tr -d '\n'`

msg_prefix='{"msg_type":"text","content":{"text":"'
msg_suffix='"}}'
msg="${msg_prefix}${msg}${msg_suffix}"

curl -s -X POST -H "Content-Type: application/json" -d "${msg}" "${url}" | awk '{print $0}'
echo "[:)] message sent to lark"
