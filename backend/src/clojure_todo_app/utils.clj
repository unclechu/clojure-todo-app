(ns clojure-todo-app.utils
  "Utilities module"
  (:gen-class))

(defn flip [f] (fn [a b] (f b a)))
