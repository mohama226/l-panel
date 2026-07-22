import Logo from "./Logo";

import "./Header.css";

interface HeaderProps {

    title?: string;

    subtitle?: string;

}

export default function Header({

    title,

    subtitle

}: HeaderProps) {

    return (

        <header className="lp-header">

            <div className="lp-header-left">

                <Logo size={52} />

            </div>

            <div className="lp-header-center">

                {title && (

                    <h2>

                        {title}

                    </h2>

                )}

                {subtitle && (

                    <p>

                        {subtitle}

                    </p>

                )}

            </div>

            <div className="lp-header-right">

                <div className="lp-status">

                    <span className="lp-status-dot"></span>

                    Online

                </div>

            </div>

        </header>

    );

}
