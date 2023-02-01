import {initializeApp} from 'firebase/app'
import {
    getAuth,
    signInWithPopup,
    GoogleAuthProvider,
    createUserWithEmailAndPassword,
    signInWithEmailAndPassword,
    signOut,
    onAuthStateChanged,
} from 'firebase/auth'
import {
    getFirestore,
    doc,
    getDoc,
    setDoc,
} from 'firebase/firestore'

const firebaseConfig = {
    apiKey: "AIzaSyBBKKOFoLJ9QpPFpopaHfYNKDKkzZQ4xVA",
    authDomain: "crwn-clothing-db-lisa.firebaseapp.com",
    projectId: "crwn-clothing-db-lisa",
    storageBucket: "crwn-clothing-db-lisa.appspot.com",
    messagingSenderId: "15690495361",
    appId: "1:15690495361:web:4326f6b411dda7cd436480"
};

// Initialize Firebase
const firebaseApp = initializeApp(firebaseConfig);

const googleProvider = new GoogleAuthProvider();

googleProvider.setCustomParameters({
    prompt: "select_account"
});

export const auth = getAuth();
export const signInWithGooglePopup = () => signInWithPopup(auth, googleProvider);

export const db = getFirestore();

export const createUserDocumentFromAuth = async (
    userAuth,
    additionalInformation = {displayName:'mike'} // overwrite the empty default name to mike;
) => {
    if(!userAuth) return;
    //db, collection, unique identifier
    const userDocRef = doc(db, 'users', userAuth.uid)

    const userSnapshot = await getDoc(userDocRef);
    // console.log(userSnapshot)
    // console.log(userSnapshot.exists())

    // is user data does not exists
    // if user data does not exist -> create / set te document with the data from userAuth in my collection
    if (!userSnapshot.exists()) {
        const {displayName, email} = userAuth;
        const createAt = new Date();

        try {
            await setDoc(userDocRef, {
                displayName,
                email,
                createAt,
                ...additionalInformation,
            })
        } catch (error) {
            console.log('error creating the user', error.message())
        }

    }
    // if user exits
    // return userDocRef
    return userDocRef;
}

export const createAuthUserWithEmailAndPassword = async (email, password) => {
    if (email ||password) {
        return await createUserWithEmailAndPassword(auth, email, password);
    }

}

export const signInAuthUserWithEmailAndPassword = async (email, password) => {
    if (email ||password) {
        return await signInWithEmailAndPassword(auth, email, password);
    };
}

export const signOUtUser = async () => await signOut(auth);

export const onAuthStateChangedListener = (callback) => onAuthStateChanged(auth, callback);