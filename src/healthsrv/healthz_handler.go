package healthsrv

import (
	"encoding/json"
	"fmt"
	"log"
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
			str := fmt.Sprintf("Probe error: listing buckets (%s)", err)
			log.Println(str)
			http.Error(w, str, http.StatusInternalServerError)
			return
		}
		if err := json.NewEncoder(w).Encode(resp{Buckets: buckets}); err != nil {
			str := fmt.Sprintf("Probe error: encoding buckets json (%s)", err)
			log.Println(str)
			http.Error(w, str, http.StatusInternalServerError)
			return
		}
	})
}
