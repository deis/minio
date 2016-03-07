package main

import (
	"testing"
)

func TestNewMinioClient(t *testing.T) {
	client, err := newMinioClient("localhost", "8095", "access_key", "access_secret_key", false)
	if err != nil {
		t.Fatalf("unexpected error creating minio client (%s)", err)
	}
	if client == nil {
		t.Fatalf("returned client was nil but not expected to be")
	}
}
