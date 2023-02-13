
## The first arg of this cmd is the env file, line format is `key=value`
env_file="${1}/env"
env=`cat "${env_file}"`
shift

## [Optional] Directly get args from `ticat <this-cmd> arg-1=<val-1> arg-2=<val-2>`
arg_1="${1}"
arg_2="${2}"
## [Recommand] Get the arg from env (the value could be provided from upstream commands)
arg_1=`env_val "${env}" 'example.key-arg-1'`
## [Recommand] Assert this value must exists, exit fail if not
arg_1=`must_env_val "${env}" 'example.key-arg-1'`

echo "arg-1: ${arg_1}"
echo "arg-2: ${arg_2}"

## [Optional] Change the env value, then the down stream command could read it
echo 'exmaple.key-arg-2=edited-val-2' >> "${env_file}"
