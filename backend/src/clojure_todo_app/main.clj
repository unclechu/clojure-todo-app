(ns clojure-todo-app.main
  "TODO list application backend main module"
  (:require
    [org.httpkit.server :refer [run-server]]
    [compojure.core :refer [defroutes GET]]
    [compojure.route :as route]
    [clojure-todo-app.cli-args-parsing :refer [cli-interface cli-action]]
    )
  (:gen-class))

(defroutes all-routes
  (GET "/" [] "hello world")
  (route/not-found "Error 404. Page not found.")
  )

(defn run-app [port]
  (assert (number? port) "Port is not a number")
  (assert (>= port 0) "Port must be greater or equal to zero")
  (println (str "Running HTTP server on port " port "…"))
  (run-server all-routes {:port port})
  )

(def -main
  (partial cli-action
    (reify cli-interface
      (smoke-test [this] (println "Smoke test passed"))
      (run-backend [this options] (run-app (:port options)))
      ))
  )
