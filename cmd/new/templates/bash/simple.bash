
## The first arg of this cmd is the env file, line format is `key=value`
env_file="${1}/env"
env=`cat "${env_file}"`
shift

## [Optional] Directly get an arg from `ticat <this-cmd> arg-1<val-1>`
arg_1="${1}"
## [Recommand] Get the arg from env (the value could be provided from upstream commands)
arg_1=`env_value "${env}" 'example.key-arg-1'`
## [Recommand] Assert this value must exists, exit fail if not
arg_1=`must_env_value "${env}" 'example.key-arg-1'`

## Do something ...

## [Optional] Change the env value, then the down stream command could read it
echo 'exmaple.key-arg-2=edited-vale-2' >> "${env_file}"
