package main

import (
	"github.com/gin-gonic/gin"
	"github.com/rabilrbl/jiotv_go/internals/handlers"
	"github.com/rabilrbl/jiotv_go/internals/television"
	"github.com/rabilrbl/jiotv_go/internals/utils"
	"html/template"
	"net/http"
)

func main() {
	r := gin.Default()

	television.Init()
	utils.Init()

	r.StaticFS("/static", http.FS(staticEmbed))
	tmpl := template.Must(template.ParseFS(tmplEmbed, "templates/*"))
	r.SetHTMLTemplate(tmpl)

	r.GET("/", handlers.IndexHandler)
	r.GET("/login", handlers.LoginHandler)
	r.GET("/live/:id", handlers.LiveHandler)
	r.GET("/render", handlers.RenderHandler)
	r.GET("/renderKey", handlers.RenderKeyHandler)
	r.GET("/channels", handlers.ChannelsHandler)
	r.GET("/play/:id", handlers.PlayHandler)
	r.Run("localhost:5001")
}