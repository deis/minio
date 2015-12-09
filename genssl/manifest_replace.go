package main

import (
	"encoding/base64"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"text/template"
)

const (
	defaultAccessCertName = "./genssl/server.cert"
	defaultAccessKeyName  = "./genssl/server.key"
	defaultTplName        = "./manifests/deis-minio-secretssl-tpl.yaml"
	defaultOutName        = "./manifests/deis-minio-secretssl-final.yaml"
)

func main() {
	accessCertName := flag.String("cert", defaultAccessCertName, "the path to the SSL certificate file")
	accessKeyName := flag.String("key", defaultAccessKeyName, "the path to the SSL key file")
	tplName := flag.String("tpl", defaultTplName, "the path to the template name")
	outName := flag.String("out", defaultOutName, "the path to the output file")

	certBytes, err := ioutil.ReadFile(*accessCertName)
	if err != nil {
		fmt.Printf("ERROR: reading cert file (%s)\n", err)
		os.Exit(1)
	}
	keyBytes, err := ioutil.ReadFile(*accessKeyName)
	if err != nil {
		fmt.Printf("ERROR: reading key file (%s)\n", err)
		os.Exit(1)
	}
	tpl, err := template.ParseFiles(*tplName)
	if err != nil {
		fmt.Printf("ERROR: parsing template (%s)\n", err)
		os.Exit(1)
	}

	outFile, err := os.Create(*outName)
	if err != nil {
		fmt.Printf("ERROR: creating new out file (%s)\n", err)
		os.Exit(1)
	}

	accessCertEncoded := base64.StdEncoding.EncodeToString(certBytes)
	accessKeyEncoded := base64.StdEncoding.EncodeToString(keyBytes)

	s := map[string]string{"AccessCert": accessCertEncoded, "AccessPem": accessKeyEncoded}

	if err := tpl.Execute(outFile, s); err != nil {
		fmt.Printf("ERROR: executing template (%s)\n", err)
		os.Exit(1)
	}
}
