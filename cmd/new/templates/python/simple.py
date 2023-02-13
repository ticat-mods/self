
from ticat import Env

if __name__ == '__main__':
    env = Env()

    ## [Optional] Directly get args from `ticat <this-cmd> arg-1=<val-1> arg-2=<val-2>`
    arg_1 = sys.argv[2]
    arg_2 = sys.argv[3]

    ## [Recommand] Get the arg from env (the value could be provided from upstream commands)
    arg_1 = env.get('example.key-arg-1')
    ## [Recommand] Assert this value must exists, exit fail if not
    arg_1 = env.must_get('example.key-arg-1')
    ## [Recommand] Get with default value
    arg_1 = env.get_ex('example.key-arg-1', 'def-val')

    print('arg-1', arg_1)
    print('arg-2', arg_2)

    ## [Optional] Change the env value, then the down stream command could read it
    env.set('exmaple.key-arg-2', 'edited-val-2')
    env.flush()
