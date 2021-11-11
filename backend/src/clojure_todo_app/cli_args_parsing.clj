(ns clojure-todo-app.cli-args-parsing
  "Command-line arguments parsing functions"
  (:require
    [clojure.string :as string]
    [clojure.tools.cli :refer [parse-opts]]
    [clojure-todo-app.utils :refer [flip]]
    )
  (:gen-class))

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

(def cli-options
  [["-p" "--port PORT" "Port number"
   :default 8080
   :parse-fn #(Integer/parseInt %)
   :validate [#(>= % 0) "Port must be greater or equal to zero"]
   ]

   ["-h" "--help"]
   ])

(defprotocol cli-interface
  "Command-line interface"
  (smoke-test [this])
  (run-backend [this options])
  )

(defn cli-action [interface & raw-cli-args]
  (let [opts (parse-opts raw-cli-args cli-options)]
    (cond
      (not= (:errors opts) nil) (cli-opts-parsing-failure (:errors opts))
      (:help (:options opts)) (show-usage (:summary opts))
      (= (:arguments opts) ["smoke-test"]) (smoke-test interface)
      (= (:arguments opts) []) (run-backend interface (:options opts))
      :else (cli-opts-parsing-failure (map pr-str (:arguments opts)))
      )
    )
  )
