package main

import (
	"log"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
)

var port = os.Getenv("PORT")

func main() {
	e := echo.New()

	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{"message": "Hello, World!"})
	})

	log.Fatal(e.Start(port))
}
