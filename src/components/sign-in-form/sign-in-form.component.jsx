/**
 * // react has onSubmit (callback function everytime you submit a form)
 *
 * */

import {useState} from "react";
import {
    createAuthUserWithEmailAndPassword,
    createUserDocumentFromAuth,
    signInWithGooglePopup
} from "../../utils/firebase/firebase.utils";
import FormInput from "../form-input/form-input.component";
import './sigg-in-form.styles.scss'
import Button from "../button/button.component";
//initial field value;
const defaultFormFields = {
    email: '',
    password: '',
}

const SignInForm = () => {
    const [formFields, setFormFields] = useState(defaultFormFields);
    const {email, password} = formFields;

    const resetFormFields = () => {
        setFormFields(defaultFormFields);
    }

    const signInWithGoogle = async () => {
        const {user} = await signInWithGooglePopup();
        await createUserDocumentFromAuth(user)
        // console.log(response);
    }

    const handleSubmit = async (event) => {
        event.preventDefault(); // no default action. we will handle all action.

        try {
            resetFormFields();
        } catch (error) {
        }
    };

    const handleChange = (event) => {
        const {name, value} = event.target;
        setFormFields({...formFields, [name]: value})
    }

    return (
        <div className='sign-up-container'>
            <h2>Already have an account</h2>
            <span>Sign in with your email and password</span>
            <form onSubmit={handleSubmit}>
                <FormInput
                    label="Email"
                    type="email"
                    required
                    onChange={handleChange}
                    name="email"
                    value={email}
                />
                <FormInput
                    label="Password"
                    type="password"
                    required
                    onChange={handleChange}
                    name="password"
                    value={password}
                />
                <Button type='submit'>Sign In</Button>
                 <Button buttonType='google' onclick={signInWithGoogle}>
                     Google sign in
                 </Button>
            </form>
        </div>
    )
}

export default SignInForm;
