package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	port := os.Getenv("PORT")

	if port == "" {
		port = "8080"
	}

	addr := fmt.Sprintf(":%s", port)

	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "Hello, World!"})
	})

	log.Fatal(e.Start(addr))
}
