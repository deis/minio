package main

import (
	"bytes"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"text/template"

	"github.com/deis/minio/src/healthsrv"
	"github.com/deis/pkg/aboutme"
	"github.com/deis/pkg/utils"
	minio "github.com/minio/minio-go"
)

const (
	localMinioScheme = "http"
	localMinioHost   = "localhost"
	localMinioPort   = 9000
)

var (
	errHealthSrvExited = errors.New("healthcheck server exited with unknown status")
	errMinioExited     = errors.New("Minio server exited with unknown status")
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

func run(cmd string) error {
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
		return err
	}
	return nil
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

	insecure := true
	if localMinioScheme == "https" {
		insecure = false
	}
	minioClient, err := minio.New(
		fmt.Sprintf("%s://%s:%d", localMinioScheme, localMinioHost, localMinioPort),
		key,
		access,
		insecure,
	)
	if err != nil {
		log.Printf("Error creating minio client (%s)", err)
		os.Exit(1)
	}

	secrets := []Secret{
		{
			Host:      pod.IP,
			KeyID:     key,
			AccessKey: access,
		},
	}
	t := template.New("MinioTpl")
	t, err = t.Parse(templv2)
	checkError(err)

	err = os.MkdirAll(configdir, 0755)
	checkError(err)
	output, err := os.Create(configdir + "config.json")
	err = t.Execute(output, secrets)
	checkError(err)
	os.Args[0] = "minio"
	mc := strings.Join(os.Args, " ")
	runErrCh := make(chan error)
	log.Printf("starting Minio server")
	go func() {
		if err := run(mc); err != nil {
			runErrCh <- err
		} else {
			runErrCh <- errMinioExited
		}
	}()

	healthSrvHost := os.Getenv("HEALTH_SERVER_HOST")
	if healthSrvHost == "" {
		healthSrvHost = healthsrv.DefaultHost
	}
	healthSrvPort, err := strconv.Atoi(os.Getenv("HEALTH_SERVER_PORT"))
	if err != nil {
		healthSrvPort = healthsrv.DefaultPort
	}

	log.Printf("starting health check server on %s:%d", healthSrvHost, healthSrvPort)

	healthSrvErrCh := make(chan error)
	go func() {
		if err := healthsrv.Start(healthSrvHost, healthSrvPort, minioClient); err != nil {
			healthSrvErrCh <- err
		} else {
			healthSrvErrCh <- errHealthSrvExited
		}
	}()

	select {
	case err := <-runErrCh:
		log.Printf("Minio server error (%s)", err)
		os.Exit(1)
	case err := <-healthSrvErrCh:
		log.Printf("Healthcheck server error (%s)", err)
		os.Exit(1)
	}
}

func checkError(err error) {
	if err != nil {
		fmt.Println("Fatal error ", err.Error())
		os.Exit(1)
	}
}
