import subprocess
import requests


class NetworkService:


    @staticmethod
    def geoip(ip):

        try:

            r = requests.get(
                f"https://ipapi.co/{ip}/json/",
                timeout=3
            )

            data = r.json()


            return {
                "country":
                    data.get("country_name","Unknown"),

                "country_code":
                    data.get("country_code",""),

            }


        except Exception:

            return {
                "country":"Unknown",
                "country_code":""
            }



    @staticmethod
    def ping(ip):

        try:

            result = subprocess.run(
                [
                    "ping",
                    "-c",
                    "1",
                    "-W",
                    "1",
                    ip
                ],
                capture_output=True,
                text=True
            )


            output=result.stdout


            if "time=" in output:

                ms=output.split(
                    "time="
                )[1].split()[0]

                return ms+" ms"


        except Exception:
            pass


        return "-"



    @staticmethod
    def enrich(session):


        ip = (
            session.get("Remote IP")
            or session.get("IP")
        )


        if not ip:

            return session



        geo=NetworkService.geoip(ip)


        session["country"] = geo["country"]

        session["country_code"] = geo["country_code"]


        session["ping"] = NetworkService.ping(ip)



        return session
