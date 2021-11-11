(ns clojure-todo-app.routes
  "Routes definition for HTTP server"
  (:require
    [compojure.core :refer [defroutes GET]]
    [compojure.route :as route]
    )
  (:gen-class))

(defroutes all-routes
  (GET "/" [] "hello world")
  (route/not-found "Error 404. Page not found.")
  )
