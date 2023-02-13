package main

import (
	"fmt"
	"os"
	"bufio"
	"strings"
)

func main() {
	args := os.Args[2:]
	env, envFilePath := readEnv()

	// [Optional] Directly get args from `ticat <this-cmd> arg-1=<val-1> arg-2=<val-2>`
	fmt.Println("arg-1:", args[0])
	fmt.Println("arg-2:", args[1])

	// [Recommand] Get the arg from env (the value could be provided from upstream commands)
	fmt.Println("read key-1:", env["example.key-arg-1"])

	// [Optional] Change the env value, then the down stream command could read it
	modifieds := map[string]string{"exmaple.key-arg-2": "edited-val-2"}
	writeEnv(envFilePath, modifieds)
}

func readEnv() (env map[string]string, path string) {
	path = os.Args[1] + "/env"
	file, err := os.Open(path)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	env = map[string]string{}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := scanner.Text()
		i := strings.Index(text, "=")
		if i < 0 {
			panic(fmt.Errorf("bad format line '%s' in env file:", text))
		}
		key := text[0:i]
		val := text[i+1:]
		env[key] = val
	}
	return env, path
}

func writeEnv(path string, pairs map[string]string) {
	file, err := os.OpenFile(path, os.O_RDWR|os.O_APPEND, 0644)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	for k, v := range pairs {
		_, err := fmt.Fprintf(file, "%s=%s\n", k, v)
		if err != nil {
			panic(err)
		}
	}
}
