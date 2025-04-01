import { useParams, useNavigate } from "react-router-dom"; 
import { useEffect } from "react";
import axios from "axios";

const Verification = () => {
    const token = useParams();
    var apiURL="";
    if (import.meta.env.NODE_ENV === 'development') {
        apiURL="http://localhost:5001";
      }
      else apiURL="http://pokeverse.space:5001";

    useEffect(() => {
        const response = axios.post(`${apiURL}/verification`, token, {
            headers: { 
              'Content-Type': 'application/json'
            }
        })
        }, []);
        const navigate = useNavigate();
        navigate("/");
    return <></>;
}

export default Verification;