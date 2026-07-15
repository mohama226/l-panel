from flask import Blueprint, render_template, request, redirect, url_for, flash
from backend.extensions import db
from backend.models.user import User
from datetime import datetime


users_bp = Blueprint(
    "users",
    __name__,
    url_prefix="/users"
)


@users_bp.route("/")
def index():

    users = User.query.order_by(
        User.id.desc()
    ).all()

    return render_template(
        "users/index.html",
        users=users
    )


# Create User
@users_bp.route("/create", methods=["GET","POST"])
def create():

    if request.method == "POST":

        username = request.form.get("username")
        password = request.form.get("password")

        user = User(
            username=username,
            password=password,
            status="active"
        )

        db.session.add(user)
        db.session.commit()

        return redirect(
            url_for("users.index")
        )

    return render_template(
        "users/create.html"
    )


# Edit User
@users_bp.route("/edit/<int:id>", methods=["GET","POST"])
def edit(id):

    user = User.query.get_or_404(id)

    if request.method == "POST":

        user.username = request.form.get("username")
        user.status = request.form.get("status")

        expire = request.form.get("expire_date")

        if expire:
            user.expire_date = datetime.strptime(
                expire,
                "%Y-%m-%d"
            )

        db.session.commit()

        return redirect(
            url_for("users.index")
        )

    return render_template(
        "users/edit.html",
        user=user
    )


# Delete User
@users_bp.route("/delete/<int:id>")
def delete(id):

    user = User.query.get_or_404(id)

    db.session.delete(user)
    db.session.commit()

    return redirect(
        url_for("users.index")
    )


# Block / Unblock
@users_bp.route("/toggle/<int:id>")
def toggle(id):

    user = User.query.get_or_404(id)

    if user.status == "active":
        user.status = "blocked"
    else:
        user.status = "active"

    db.session.commit()

    return redirect(
        url_for("users.index")
    )


# ===============================
# User Profile
# ===============================
@users_bp.route("/profile/<int:id>")
def profile(id):

    user = User.query.get_or_404(id)

    return render_template(
        "users/profile.html",
        user=user
    )
