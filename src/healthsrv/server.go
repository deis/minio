package healthsrv

import (
	"fmt"
	"net/http"
)

const (
	DefaultHost = "0.0.0.0"
	DefaultPort = 8082
)

// Start starts the healthcheck server on $host:$port and blocks. It only returns if the server fails, with the indicative error
func Start(host string, port int) error {
	mux := http.NewServeMux()
	mux.Handle("/healthz", healthZHandler())

	hostStr := fmt.Sprintf("%s:%d", host, port)
	return http.ListenAndServe(hostStr, mux)
}
