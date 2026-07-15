from backend.models import Session


class SessionService:


    @staticmethod
    def online():

        return Session.query.filter_by(
            active=True
        ).all()



    @staticmethod
    def disconnect(session):

        session.active=False

        from backend.extensions import db

        db.session.commit()

        return True
