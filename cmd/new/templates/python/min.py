
from ticat import Env

if __name__ == '__main__':
    env = Env()
    arg_1 = env.must_get('example.key-arg-1')
    print('example.key-arg-1 =', arg_1)
