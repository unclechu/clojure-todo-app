(ns clojure-todo-app.routes
  "Routes definition for HTTP server"
  (:require
    [compojure.core :refer [defroutes GET]]
    [compojure.route :as route]
    [ring.util.response :refer [response]]
    )
  (:gen-class))

(def health-counter (atom 0))

(defn plain-text-response [body]
  {:headers {"Content-Type" "text/plain; charset=utf-8"}
   :body body
   }
  )

(defn health-counter-handler []
  (let [x (swap-vals! health-counter #(inc %))]
    (response {:counter (last x)})
    )
  )

(defroutes all-routes
  (GET "/" [] (plain-text-response "Hello world!"))
  (GET "/health" [] (health-counter-handler))
  (route/not-found (plain-text-response "Error 404. Page not found."))
  )
