import {
    signInWithGooglePopup,
    createUserDocumentFromAuth,
} from '../../utils/firebase/firebase.utils'

const SignIn = () => {
    // the useEffect will run this call back once on the mounting.
    // inside the callback, get the response for the redirect just happened.
    // how do we know the redirect happened? -> auth is helping us to keep track of all those authentication states

    const logGoogleUser = async () => {
        const {user} = await signInWithGooglePopup();
        const userDocRef = await createUserDocumentFromAuth(user)
        // console.log(response);
    };

    return (
        <div>
            <h1>I am the sign in page</h1>
            <button onClick={logGoogleUser}>Sign in with Google</button>
        </div>
    )
}

export default SignIn;