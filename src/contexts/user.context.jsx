/**
 * we want to store the user state through context,
 * to pass the user login state in different component 
 * (sign in, purchase history, setting et )
 * 
 */

import { useState } from "react";
import { createContext } from "react";

// default values 
// as the actual value you want to access
export const UserContext = createContext({

})

// provider is the actual component.

export const UserProvider = ({ children }) => {
    const [currentUser, setCurrentUser] = useState(null);
    const value = {currentUser, setCurrentUser}
    // this provider allow all its {children} to access the state (currentUser / setCurrentUser)
    return <UserContext.Provider value={value}>{children}</UserContext.Provider>
}

//  <UserProvider>
//     <App />
// </UserProvider> 
