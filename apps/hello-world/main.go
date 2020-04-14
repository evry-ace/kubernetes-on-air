package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/evry-ace/kubernetes-on-air/apps/hello-world/api"
)

func main() {
	router := api.MakeRouter()

	server := http.Server{
		Addr:    "0.0.0.0:8080",
		Handler: router,
	}

	fmt.Println("Server is listening on port 8080")

	log.Fatal(server.ListenAndServe())
}
