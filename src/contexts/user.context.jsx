/**
 * we want to store the user state through context,
 * to pass the user login state in different component
 * (sign in, purchase history, setting et )
 *
 */

/**
 * observe mode
 *
 */

import {useState, createContext, useEffect} from "react";

import {
    onAuthStateChangedListener,
    createUserDocumentFromAuth,
} from "../utils/firebase/firebase.utils";


// default values 
// as the actual value you want to access
export const UserContext = createContext({
    currentUser: null,
    setCurrentUser: () => null,
})

// provider is the actual component.

export const UserProvider = ({children}) => {
    const [currentUser, setCurrentUser] = useState(null);
    const value = {currentUser, setCurrentUser}
    // this provider allows all its {children} to access the state (currentUser / setCurrentUser)


    // onAuthStateChangedListener（auth, callback）, this callback will be evoked, whenever the auth state was changed.
    // if the component unmount, this won't need to be listener anymore
    // sign out -> (user) null ; sign in -> (user)user object.
    useEffect(() => {
        const unsubscribe = onAuthStateChangedListener((user) => {
            if (user) {
                createUserDocumentFromAuth(user)
            }
            setCurrentUser(user);
        })
        return unsubscribe;
    }, [])


    return <UserContext.Provider value={value}>{children}</UserContext.Provider>
}

//  <UserProvider>
//     <App />
// </UserProvider> 
