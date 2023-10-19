package handlers

import "github.com/gofiber/fiber/v2"

type Handler struct {
	Method       string
	Path         string
	HandlerFuncs []fiber.Handler
}

var Handlers []Handler

func init() {
	Handlers = []Handler{
		{
			Method:       "get",
			Path:         "/",
			HandlerFuncs: []fiber.Handler{HelloOpenCore},
		},
	}
}

func HelloOpenCore(c *fiber.Ctx) (err error) {
	return c.SendString("Open Core Service")
}
