import { createBrowserRouter } from "react-router-dom";

import Login from "@pages/Login/Login";

const router = createBrowserRouter([
    {
        path: "/",
        element: <Login />
    },
    {
        path: "/login",
        element: <Login />
    }
]);

export default router;
