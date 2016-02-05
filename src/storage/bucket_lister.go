package storage

import (
	minio "github.com/minio/minio-go"
)

// BucketLister is an interface that knows how to list buckets on object storage
type BucketLister interface {
	ListBuckets() ([]minio.BucketInfo, error)
}

type fakeBucketLister struct {
	bucketInfos []minio.BucketInfo
}

func NewFakeBucketLister(buckets []minio.BucketInfo) BucketLister {
	return &fakeBucketLister{bucketInfos: buckets}
}

func (b *fakeBucketLister) ListBuckets() ([]minio.BucketInfo, error) {
	return b.bucketInfos, nil
}
