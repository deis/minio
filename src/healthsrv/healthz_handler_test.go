package healthsrv

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/deis/minio/src/storage"
	minio "github.com/minio/minio-go"
)

func TestHealthzHandler(t *testing.T) {
	buckets := []minio.BucketInfo{
		minio.BucketInfo{Name: "bucket1", CreationDate: time.Now()},
		minio.BucketInfo{Name: "bucket2", CreationDate: time.Now()},
	}
	bucketLister := storage.NewFakeBucketLister(buckets)
	handler := healthZHandler(bucketLister)

	w := httptest.NewRecorder()
	r, err := http.NewRequest("GET", "/healthz", bytes.NewReader(nil))
	if err != nil {
		t.Fatalf("unexpected error creating request (%s)", err)
	}
	handler.ServeHTTP(w, r)
	if w.Code != http.StatusOK {
		t.Fatalf("unexpected response code %d", w.Code)
	}

	rsp := new(healthZResp)
	if err := json.NewDecoder(w.Body).Decode(rsp); err != nil {
		t.Fatalf("error decoding json (%s)", err)
	}
	if len(rsp.Buckets) != len(buckets) {
		t.Fatalf("received %d bucket(s), expected %d", len(rsp.Buckets), len(buckets))
	}

	for i, bucket := range buckets {
		actual := rsp.Buckets[i]
		if actual.Name != bucket.Name {
			t.Fatalf("expected name %s for bucket %d, got %s", bucket.Name, i, actual.Name)
		}
		if !actual.CreationDate.Equal(bucket.CreationDate) {
			t.Fatalf("expected creation date %s for bucket %d, got %s", bucket.CreationDate, i, actual.CreationDate)
		}
	}
}
