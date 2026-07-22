import { ReactNode } from "react";
import "./AuthLayout.css";

interface AuthLayoutProps {
    children: ReactNode;
}

export default function AuthLayout({ children }: AuthLayoutProps) {
    return (
        <div className="auth-layout">

            <div className="auth-background">
                <div className="circle circle-1"></div>
                <div className="circle circle-2"></div>
                <div className="circle circle-3"></div>
            </div>

            <div className="auth-left">

                <div className="brand">

                    <div className="brand-logo">
                        L
                    </div>

                    <h1>L-PANEL</h1>

                    <p>
                        Enterprise VPN Management
                    </p>

                </div>

                <div className="features">

                    <div>✓ Ocserv VPN</div>

                    <div>✓ OpenConnect</div>

                    <div>✓ Real-Time Monitoring</div>

                    <div>✓ Firewall Manager</div>

                    <div>✓ SSL Manager</div>

                    <div>✓ Enterprise Security</div>

                </div>

            </div>

            <div className="auth-right">

                {children}

            </div>

        </div>
    );
}
