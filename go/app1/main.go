package main

import (
	"fmt"
	"net/http"

	"example.com/hello/hello"
	"go.uber.org/zap"
)

var logger *zap.Logger

func init() {
	logger, _ = zap.NewProduction()
	defer logger.Sync()
}

func root(w http.ResponseWriter, r *http.Request) {
	logger.Info("/ called")
	fmt.Fprintf(w, "app1 says %s", hello.Hello())
}

func health(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "ok")
}

func main() {
	http.HandleFunc("/", root)
	http.HandleFunc("/health", health)
	logger.Info("App1 listening 8080")
	logger.Fatal("HTTP Server error", zap.Error(http.ListenAndServe(":8080", nil)))
}
