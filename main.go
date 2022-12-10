package main

import (
	"fmt"
	"net/http"
)

func main() {
	// This is a good spot for a breakpoint :)
	http.HandleFunc("/hello", hello)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}

func hello(w http.ResponseWriter, req *http.Request) {
	// Try setting a breakpoint here too :)
	if _, err := fmt.Fprintf(w, "Hello world!\n"); err != nil {
		panic(err)
	}
}
