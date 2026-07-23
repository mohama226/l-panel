import api from "./api";


export interface LoginResponse {

    success:boolean;

    token?:string;

    user?:{

        username:string;

        role:string;

    };

    message?:string;

}



export async function login(

    username:string,

    password:string

):Promise<LoginResponse>{


    try{


        const response = await api.post(

            "/login",

            {

                username,

                password

            }

        );


        if(response.data.token){

            localStorage.setItem(

                "lpanel_token",

                response.data.token

            );

        }


        return response.data;



    }catch(error:any){


        return {

            success:false,

            message:

            error?.response?.data?.message

            ||

            "Login failed"

        };


    }


}



export function logout(){

    localStorage.removeItem(

        "lpanel_token"

    );



    window.location.href="/login";

}



export function isAuthenticated(){

    return Boolean(

        localStorage.getItem(

            "lpanel_token"

        )

    );

}
