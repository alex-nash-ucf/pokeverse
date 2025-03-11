import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

const LoginForm = () => {
  const [message, setMessage] = useState("");
  const [loginName, setLoginName] = useState("");
  const [loginPassword, setLoginPassword] = useState("");
  const navigate = useNavigate();


  const handleSetLoginName = (e: React.ChangeEvent<HTMLInputElement>): void => {
    setLoginName(e.target.value);
  };

  const handleSetPassword = (e: React.ChangeEvent<HTMLInputElement>): void => {
    setLoginPassword(e.target.value);
  };

  const doLogin = async (event: React.FormEvent): Promise<void> => {
    event.preventDefault();
  
    const obj = { login: loginName, password: loginPassword };
    const js = JSON.stringify(obj);
  
    try {
      const response = await fetch("http://localhost:5001/userlogin", {
        method: "POST",
        body: js,
        headers: { "Content-Type": "application/json" },
      });
  
      if (!response.ok) {
        setMessage("Error: Invalid response from server");
        return;
      }
  
      const res = await response.json();
      console.log("Login response:", res);
  
      if (!res || !res.id) {  
        setMessage("User/Password combination incorrect");
        return;
      }
  
      const user= { username: res.user, email: res.email, id: res.id };
      localStorage.setItem("user_data", JSON.stringify(user));
  
      setMessage("");
      navigate("/loggedIn"); 
    } catch (error) {
      setMessage("Error occurred during login");
      console.error("Login error:", error);
    }
  };
  
  return (
    <div className="w-1/2 p-6 login-box">
      <form onSubmit={doLogin} className="bg-transparent">
        <div className="mb-4">
          <label htmlFor="user" className="block text-sm font-medium text-gray-700"></label>
          <input
            type="text"
            id="user"
            name="user"
            required
            className="w-full p-3 border border-gray-300 text-[13px] rounded-md"
            placeholder="Username"
            value={loginName}
            onChange={handleSetLoginName}
          />
        </div>

        <div className="mb-4">
          <label htmlFor="password" className="block text-sm font-medium text-gray-700"></label>
          <input
            type="password"
            id="password"
            name="password"
            required
            className="w-full p-3 border text-[13px] border-gray-300 rounded-md"
            placeholder="Password"
            value={loginPassword}
            onChange={handleSetPassword}
          />
        </div>

        {message&& <p className="text-red-500 text-sm mb-4">{message}</p>}

        <button
          type="submit"
          className="login-btn w-full bg-red-600 text-white py-3 rounded-md"
        >
          Login
        </button>

        <div className="mt-4 text-center font-[PokemonFont] text-[10px]">
          Forgot Password?
          <a href="/resetpass" className="font-medium !text-red-600 !underline !hover:text-red-700 ml-2">
            Reset here
          </a>
        </div>
      </form>
    </div>
  );
};

export default LoginForm;