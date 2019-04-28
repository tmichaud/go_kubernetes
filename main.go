package main

import (
	"context"
	"go_kubernetes/handlers"
	"go_kubernetes/version"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	log.Printf("Starting the service...\ncommit: %s, build time: %s, release: %s\n", version.Commit, version.BuildTime, version.Release)
	port := os.Getenv("PORT")
	if port == "" {
		log.Fatal("Port is not set")
	}
	log.Printf("Port is %v\n", port)
	r := handlers.Router(version.BuildTime, version.Commit, version.Release)

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt, syscall.SIGTERM)

	srv := &http.Server{
		Addr:    ":" + port,
		Handler: r,
	}

	go func() {
		log.Fatal(srv.ListenAndServe())
	}()

	log.Print("The service is ready to listen and serve")

	killSignal := <-interrupt
	switch killSignal {
	case os.Interrupt:
		log.Print("Got SIGINT...")
	case syscall.SIGTERM:
		log.Print("Got SIGTERM...")
	}

	log.Print("The service is shutting down...")
	srv.Shutdown(context.Background())
	log.Print("Done")

	//log.Fatal(http.ListenAndServe(":"+port, r ))
	//log.Fatal(http.ListenAndServe(":8080", r))
}
