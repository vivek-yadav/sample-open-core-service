//go:build closed
// +build closed

package advancedhandlers

import (
	"log"

	"github.com/vivek-yadav/sample-closed-core-lib/closedhandlers"
)

func init() {
	log.Println("closedhandlers.INIT: ", closedhandlers.INIT)
}
