set -euo pipefail
. "`cd $(dirname ${BASH_SOURCE[0]}) && pwd`/../../helper/helper.bash"

env=`cat "${1}/env"`
shift

ticat=`must_env_val "${env}" 'sys.paths.ticat'`
session=`must_env_val "${env}" 'sys.session.id'`
url=`must_env_val "${env}" 'lark.secret.notify-url'`

set +e
msg=`"${ticat}" {sys.session.disable=true} display.quiet : display.tips.off : display.plain : \
	echo "[${session}] - [[sys.session.id.ip]]" : sessions.desc "${session}" 2 2>&1`
set -e

if [ -z "${msg}" ]; then
	msg="can't get info from session '${session}'"
fi

# This maybe not right under MacOS
msg=`echo "${msg}" | sed '$!s/$/\\\n/' | tr -d '\n'`

msg_prefix='{"msg_type":"text","content":{"text":"'
msg_suffix='"}}'
msg="${msg_prefix}${msg}${msg_suffix}"

set +e
result=`curl -s -X POST -H "Content-Type: application/json" -d "${msg}" "${url}" 2>&1`
set -e
ok=`echo "${result}" | { grep 'success' || test $? = 1; } `

if [ ! -z "${ok}" ]; then
	echo "[:)] message sent to lark"
	exit
fi

echo "******" >&2
echo "${msg}" >&2
echo "******" >&2
echo "[:(] message sent to lark failed: ${result}" >&2

echo "[:-] remedy message sending" >&2
remedy_msg="${msg_prefix}ticat session exited, but sending gathered-info to lark failed, plz check the log${msg_suffix}"

set +e
curl -s -X POST -H "Content-Type: application/json" -d "${remedy_msg}" "${url}" 2>&1 | awk '{print "[:-] "$0}'
ret=${?}
set -e

if [ ${ret} == 0 ]; then
	echo "[:-] remedy message sent" >&2
fi
