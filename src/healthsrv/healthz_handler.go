package healthsrv

import (
	"encoding/json"
	"fmt"
	"net/http"

	minio "github.com/minio/minio-go"
)

func healthZHandler(minioClient minio.CloudStorageClient) http.Handler {
	type resp struct {
		Buckets []minio.BucketInfo `json:"buckets"`
	}
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		buckets, err := minioClient.ListBuckets()
		if err != nil {
			http.Error(w, fmt.Sprintf("Error listing buckets (%s)", err), http.StatusInternalServerError)
			return
		}
		if err := json.NewEncoder(w).Encode(resp{Buckets: buckets}); err != nil {
			http.Error(w, fmt.Sprintf("Error encoding buckets json (%s)", err), http.StatusInternalServerError)
			return
		}
	})
}
