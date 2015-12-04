package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strings"
	"text/template"

	"github.com/deis/pkg/aboutme"
	"github.com/deis/pkg/utils"
)

// Secret is a secret for the remote object storage
type Secret struct {
	Host      string
	KeyID     string
	AccessKey string
}

const configdir = "/home/minio/.minio/"
const templv3 = `{
	"version": "3",
	"alias": {
		"dl": "https://dl.minio.io:9000",
		"localhost": "http://localhost:9000",
		"play": "https://play.minio.io:9000",
		"s3": "https://s3.amazonaws.com"
	},
  "hosts": {
  {{range .}}
		"{{.Host}}": {
			"access-key-id": "{{.KeyID}}" ,
			"secret-access-key": "{{.AccessKey}}"
		},
    {{end}}
		"127.0.0.1:*": {
			"access-key-id": "",
			"secret-access-key": ""
		}
	}
}
`

const templv2 = `{
	"version": "2",
	"credentials": {
  {{range .}}
		"accessKeyId": "{{.KeyID}}",
		"secretAccessKey": "{{.AccessKey}}"
  {{end}}
	},
	"mongoLogger": {
		"addr": "",
		"db": "",
		"collection": ""
	},
	"syslogLogger": {
		"network": "",
		"addr": ""
	},
	"fileLogger": {
		"filename": ""
	}
}`

func run(cmd string) {
	var cmdBuf bytes.Buffer
	tmpl := template.Must(template.New("cmd").Parse(cmd))
	if err := tmpl.Execute(&cmdBuf, nil); err != nil {
		log.Fatal(err)
	}
	cmdString := cmdBuf.String()
	fmt.Println(cmdString)
	var cmdl *exec.Cmd
	cmdl = exec.Command("sh", "-c", cmdString)
	if _, _, err := utils.RunCommandWithStdoutStderr(cmdl); err != nil {
		log.Fatal(err)
	} else {
		fmt.Println("ok")
	}
}

func readSecrets() (string, string) {
	keyID, err := ioutil.ReadFile("/var/run/secrets/deis/minio/user/access-key-id")
	checkError(err)
	accessKey, err := ioutil.ReadFile("/var/run/secrets/deis/minio/user/access-secret-key")
	checkError(err)
	return strings.TrimSpace(string(keyID)), strings.TrimSpace(string(accessKey))
}

func main() {
	pod, err := aboutme.FromEnv()
	checkError(err)
	key, access := readSecrets()
	secrets := []Secret{
		{
			Host:      pod.IP,
			KeyID:     key,
			AccessKey: access,
		},
	}
	t := template.New("Secret template")

	t, err = t.Parse(templv2)

	checkError(err)
	err = os.MkdirAll(configdir, 0755)
	checkError(err)
	output, err := os.Create(configdir + "config.json")
	err = t.Execute(output, secrets)
	checkError(err)
	os.Args[0] = "minio"
	mc := strings.Join(os.Args, " ")
	run(mc)
}

func checkError(err error) {
	if err != nil {
		fmt.Println("Fatal error ", err.Error())
		os.Exit(1)
	}
}
