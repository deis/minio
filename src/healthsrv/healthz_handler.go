package healthsrv

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/deis/minio/src/storage"
	minio "github.com/minio/minio-go"
)

type healthZResp struct {
	Buckets []minio.BucketInfo `json:"buckets"`
}

func healthZHandler(bucketLister storage.BucketLister) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		buckets, err := bucketLister.ListBuckets()
		if err != nil {
			str := fmt.Sprintf("Probe error: listing buckets (%s)", err)
			log.Println(str)
			http.Error(w, str, http.StatusInternalServerError)
			return
		}
		if err := json.NewEncoder(w).Encode(healthZResp{Buckets: buckets}); err != nil {
			str := fmt.Sprintf("Probe error: encoding buckets json (%s)", err)
			log.Println(str)
			http.Error(w, str, http.StatusInternalServerError)
			return
		}
	})
}
