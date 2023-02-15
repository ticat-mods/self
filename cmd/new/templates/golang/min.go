package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	env, envFilePath := readEnv()
	fmt.Println("example.key-arg-1 =", env["example.key-arg-1"])
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
