package routes

import (
	controller "kharchasathi.com/controllers"

	"github.com/gin-gonic/gin"
)

func TransactionRouter(router *gin.Engine) {
	router.GET("/transaction", controller.GetTransactions())
}
