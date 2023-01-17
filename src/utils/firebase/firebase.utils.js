import { initializeApp } from 'firebase/app'
import {
    getAuth,
    signInWithRedirect,
    signInWithPopup,
    GoogleAuthProvider
} from 'firebase/auth'
import{
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

const provider = new GoogleAuthProvider();

provider.setCustomParameters({
    prompt: "select_account"
});

export const auth = getAuth();
export const signInWithGooglePopup = () => signInWithPopup(auth, provider);

const db = getFirestore();

export const createUserDocumentFromAuth = async(userAuth) => {
    //db, collection, unique identifier
    const userDocRef = doc(db, 'users', userAuth.uid)

    console.log(userDocRef)
}