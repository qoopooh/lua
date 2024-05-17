package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func getPort() string {
	value := os.Getenv("PORT")
	if value == "" {
		return "8081"
	}
	return value
}

func main() {
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {

		queryParam := c.Query("q")
		if queryParam == "" {
			queryParam = "Gin"
		}

		c.String(http.StatusOK, "Hello, %s!", queryParam)
	})
	r.Run(":" + getPort())
}
