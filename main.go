package main

import (
	"go_kubernetes/handlers"
	"go_kubernetes/version"
	"log"
	"net/http"
	"os"
)

func main() {
	log.Printf("Starting the service...\ncommit: %s, build time: %s, release: %s\n", version.Commit, version.BuildTime, version.Release)
	port := os.Getenv("PORT")
	if port == "" {
		log.Fatal("Port is not set")
	}
	log.Printf("Port is %v\n", port)
	r := handlers.Router()
	//	http.HandleFunc("/home", func(w http.ResponseWriter, _ *http.Request) {
	//		fmt.Fprint(w, "Hello! Your request was processed.")
	//	},
	//	)
	log.Print("The service is ready to listen and serve")
	//log.Fatal(http.ListenAndServe(":"+port, r ))
	log.Fatal(http.ListenAndServe(":8080", r))
}
