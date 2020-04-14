package api

import (
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

func GetPodNameHandler(w http.ResponseWriter, r *http.Request) {
	myName := os.Getenv("MY_POD_NAME")
	if myName == "" {
		myName = "N/A"
	}

	w.Write([]byte(myName))
}

func isOkHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(200)
	w.Write([]byte("OK"))
}

func MakeRouter() *mux.Router {
	router := mux.NewRouter()
	router.Methods("GET").Path("/").HandlerFunc(GetPodNameHandler)
	router.Methods("GET").Path("/is_alive").HandlerFunc(isOkHandler)
	return router
}
