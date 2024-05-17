package main

import (
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
		c.String(200, "Hello, Gin!")
	})
	r.Run(":" + getPort())
}
