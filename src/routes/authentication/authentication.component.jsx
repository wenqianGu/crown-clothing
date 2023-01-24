
import SignUpForm from "../../components/sign-up-form/sign-up-form.component";
import SignInForm from "../../components/sign-in-form/sign-in-form.component";

import './authentication.styles.scss'

const Authentication = () => {
    // the useEffect will run this call back once on the mounting.
    // inside the callback, get the response for the redirect just happened.
    // how do we know the redirect happened? -> auth is helping us to keep track of all those authentication states



    return (
        <div className="authentication-container">
            <SignInForm />
            <SignUpForm />
        </div>
    )
}

export default Authentication;