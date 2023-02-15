
env=`cat "${1}/env"`

echo "example.key-arg-1 = "`env_val "${env}" 'example.key-arg-1'`
