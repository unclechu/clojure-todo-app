(ns clojure-todo-app.main
  "TODO list application backend main module"
  (:require
    [org.httpkit.server :refer [run-server]]
    [clojure-todo-app.cli-args-parsing :refer [cli-interface cli-action]]
    [clojure-todo-app.routes :refer [all-routes]]
    [ring.middleware.json :refer [wrap-json-response wrap-json-body]]
    )
  (:gen-class))

(defn run-app [port]
  (assert (number? port) "Port is not a number")
  (assert (>= port 0) "Port must be greater or equal to zero")
  (println (str "Running HTTP server on port " port "…"))
  (run-server (->> all-routes wrap-json-body wrap-json-response) {:port port})
  )

(def -main
  (partial cli-action
    (reify cli-interface
      (smoke-test [this] (println "Smoke test passed"))
      (run-backend [this options] (run-app (:port options)))
      ))
  )
