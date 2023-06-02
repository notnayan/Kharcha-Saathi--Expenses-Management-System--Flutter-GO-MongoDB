package main

import (
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"kharchasathi.com/routes"
)

func main() {

	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	router := gin.New()
	router.Use(gin.Logger())

	// Add the CORS middleware
	router.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders: []string{"Content-Type", "Authorization"},
	}))

	routes.UserRouter(router)
	routes.TransactionRouter(router)

	router.GET("/", func(c *gin.Context) {
		c.String(200, "Server Running. Listening on port "+port)
	})

	router.Run(":" + port)
}
