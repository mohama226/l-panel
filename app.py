from flask import Flask,render_template,request,redirect,session

from config import Config
from database import db

from models.admin import Admin

from werkzeug.security import generate_password_hash,check_password_hash



app = Flask(__name__)

app.config.from_object(Config)


db.init_app(app)



with app.app_context():

    db.create_all()

    if not Admin.query.first():

        admin = Admin(
            username="admin",
            password=generate_password_hash("admin123")
        )

        db.session.add(admin)
        db.session.commit()



@app.route("/",methods=["GET","POST"])
def login():

    if request.method=="POST":

        user=request.form["username"]
        password=request.form["password"]


        admin=Admin.query.filter_by(
            username=user
        ).first()


        if admin and check_password_hash(
            admin.password,
            password
        ):

            session["admin"]=admin.username

            return redirect("/dashboard")


    return render_template("login.html")




@app.route("/dashboard")
def dashboard():

    if "admin" not in session:
        return redirect("/")


    return render_template(
        "dashboard.html"
    )



if __name__=="__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )
