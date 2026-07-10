import subprocess


class PingService:


    @staticmethod
    def ping(ip):

        try:

            result=subprocess.run(

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

                return output.split("time=")[1].split(" ")[0]+" ms"


        except:

            pass


        return "-"
