import { ButtonHTMLAttributes } from "react";
import clsx from "clsx";

type ButtonVariant = "primary" | "secondary" | "danger";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
    variant?: ButtonVariant;
    loading?: boolean;
}

export default function Button({
    variant = "primary",
    loading = false,
    className,
    children,
    disabled,
    ...props
}: ButtonProps) {

    return (

        <button
            className={clsx(
                "lp-button",
                `lp-button-${variant}`,
                className
            )}
            disabled={disabled || loading}
            {...props}
        >

            {loading ? "Loading..." : children}

        </button>

    );

}
