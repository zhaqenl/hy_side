(require [hy.contrib.walk [let]])

(import [flask [Flask render_template request make_response]])

(setv app (Flask "Flash and Jinja2 test"))

(with-decorator (app.route "/hy_flask")
  (defn index []
    (setv minuend (request.cookies.get "minuend"))
    (setv subtrahend (request.cookies.get "subtrahend"))
    (setv difference (request.cookies.get "difference"))
    (render_template "flask_diff.j2"
                     :minuend minuend
                     :subtrahend subtrahend
                     :difference difference)))

(with-decorator (app.route "/hy_flask/response" :methods ["POST"])
  (defn response []
    (setv minuend (float (request.form.get "minuend")))
    (setv subtrahend (float (request.form.get "subtrahend")))
    (setv difference (- minuend subtrahend))
    (setv resp (make_response (render_template "flask_diff.j2"
                                               :minuend minuend
                                               :subtrahend subtrahend
                                               :difference difference)))
    (resp.set_cookie "minuend" (str minuend))
    (resp.set_cookie "subtrahend" (str subtrahend))
    (resp.set_cookie "difference" (str difference))
    resp))

(app.run :debug True)
