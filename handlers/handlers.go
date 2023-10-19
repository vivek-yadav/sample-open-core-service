package handlers

import (
	"log"

	"github.com/gofiber/fiber/v2"
)

type Handler struct {
	Method       string
	Path         string
	HandlerFuncs []fiber.Handler
}

var Handlers []Handler

func init() {
	log.Println("In handlers")
	handlers := []Handler{
		{
			Method:       "get",
			Path:         "/",
			HandlerFuncs: []fiber.Handler{HelloOpenCore},
		},
	}
	Handlers = append(Handlers, handlers...)
}

func HelloOpenCore(c *fiber.Ctx) (err error) {
	return c.SendString("Open Core Service")
}
