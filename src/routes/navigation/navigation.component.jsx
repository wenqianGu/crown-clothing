import { Fragment, useContext } from "react";
import { Outlet, Link } from "react-router-dom";

import { ReactComponent as CrwnLogo } from '../../assets/crown.svg'
import { UserContext } from "../../contexts/user.context";

import { signOUtUser } from "../../utils/firebase/firebase.utils";

import './navigation.styles.scss'

const Navigation = () => {
    // get the current user from  'UserContext'
    const { currentUser } = useContext(UserContext)


    // const signOutHandler = async () => {
    //     const res = await signOUtUser()
    //    // console.log(res);
    //     setCurrentUser(null);
    // }


    return (
        <Fragment>
            <div className="navigation">
                <Link className="logo-container" to='/'>
                    <CrwnLogo className="logo" />
                </Link>
                <div className="nav-links-container">
                    <Link className="nav-link" to='/shop'>
                        SHOPS
                    </Link>
                    {
                        currentUser ? (
                            <span className="nav-link" onClick={signOUtUser}>SIGN OUT</span>
                        ) : (
                            <Link className="nav-link" to='/auth'>
                                SIGN IN
                            </Link>
                        )
                    }
                </div>
            </div>
            <Outlet />
        </Fragment>
    );
};

export default Navigation;