import {
    forwardRef,
    InputHTMLAttributes
} from "react";

import clsx from "clsx";

interface InputProps
    extends InputHTMLAttributes<HTMLInputElement> {

    label?: string;

    error?: string;

}

const Input = forwardRef<HTMLInputElement, InputProps>(
    (
        {
            label,
            error,
            className,
            ...props
        },
        ref
    ) => {

        return (

            <div className="lp-input-group">

                {label && (

                    <label className="lp-label">

                        {label}

                    </label>

                )}

                <input

                    ref={ref}

                    className={clsx(
                        "lp-input",
                        error && "lp-input-error",
                        className
                    )}

                    {...props}

                />

                {

                    error && (

                        <span className="lp-error">

                            {error}

                        </span>

                    )

                }

            </div>

        );

    }
);

Input.displayName = "Input";

export default Input;
