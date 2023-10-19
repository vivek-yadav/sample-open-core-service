package main

import (
	"log"

	"github.com/gofiber/fiber/v2"
	"github.com/vivek-yadav/sample-open-core-service/advancedhandlers"
	"github.com/vivek-yadav/sample-open-core-service/handlers"
)

func main() {
	app := fiber.New()

	for _, h := range handlers.Handlers {
		app.Add(h.Method, h.Path, h.HandlerFuncs...)
	}

	log.Println("import advanced handlers", advancedhandlers.INIT)

	log.Println(app.GetRoutes())

	log.Fatal(app.Listen(":3000"))
}
