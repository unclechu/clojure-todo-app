(ns clojure-todo-app.main
  "TODO list application backend main module"
  (:require
    [clojure.string :as string]
    [clojure.tools.cli :refer [parse-opts]]
    [org.httpkit.server :refer [run-server]]
    [compojure.core :refer [defroutes GET]]
    [compojure.route :as route]
    [clojure-todo-app.utils :refer [flip]]
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

(def cli-options
  [["-p" "--port PORT" "Port number"
   :default 8080
   :parse-fn #(Integer/parseInt %)
   :validate [#(>= % 0) "Port must be greater or equal to zero"]
   ]

   ["-h" "--help"]
   ])

(defn cli-opts-parsing-failure
  [errors]
  (.println *err*
    (->> errors
      (cons "Arguments parsing failure:")
      ((flip concat) ["" "Call the app with “--help” to see usage info."])
      (string/join \newline)
      ))
  (System/exit 1)
  )

(defn show-usage [summary]
  (println "Supported arguments:")
  (println summary)
  )

(defn -main [& args]
  (let [opts (parse-opts args cli-options)]
    (cond
      (not= (:errors opts) nil) (cli-opts-parsing-failure (:errors opts))
      (:help (:options opts)) (show-usage (:summary opts))
      (= (:arguments opts) ["smoke-test"]) (println "Smoke test passed")
      (= (:arguments opts) []) (run-app (:port (:options opts)))
      :else (cli-opts-parsing-failure (map pr-str (:arguments opts)))
      )
    )
  )
