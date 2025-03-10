import React, { useState } from "react";

const SignUpForm = () => {
    const [message, setMessage] = useState("");
    const [firstName, setFirstName] = useState("");
    const [lastName, setLastName] = useState("");
    const [email, setEmail] = useState("");
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
  
    const handleSetFirstName= (e: React.ChangeEvent<HTMLInputElement>): void => {
      setFirstName(e.target.value);
    };
  
    const handleSetLastName= (e: React.ChangeEvent<HTMLInputElement>): void => {
      setLastName(e.target.value);
    };
  
    const handleSetEmail= (e: React.ChangeEvent<HTMLInputElement>): void => {
      setEmail(e.target.value);
    };
  
    const handleSetUsername= (e: React.ChangeEvent<HTMLInputElement>): void => {
      setUsername(e.target.value);
    };
  
    const handleSetPassword= (e: React.ChangeEvent<HTMLInputElement>): void => {
      setPassword(e.target.value);
    };
  
    const doSignUp= async (event: React.FormEvent): Promise<void> => {
      event.preventDefault();
  
      const userData= {
        firstName,
        lastName,
        email,
        username,
        password,
      };
  
      const js= JSON.stringify(userData);
  
      try {
        const response = await fetch("http://localhost:5000/api/signup", {
          method: "POST",
          body: js,
          headers: { "Content-Type": "application/json" },
        });
  
        const res= await response.json();
  
        if(res.id <= 0){
          setMessage("Signup failed. Please try again.");
        } else {
          const user = { firstName: res.firstName, lastName: res.lastName, id: res.id };
          localStorage.setItem("user_data", JSON.stringify(user));
  
          setMessage("Signup successful! Redirecting to login...");
          setTimeout(() => {
            //redirect link here
            window.location.href = "/";
          }, 2000);
        }
      } catch (error) {
        setMessage("Error occurred during signup");
        console.error(error);
      }
    };
  
  return (
    <div className="w-1/2 p-6 signup-box">
      <form onSubmit={doSignUp} className="bg-transparent w-8/10 ml-10 pt-2">
        <div className="mb-2">
          <label htmlFor="firstName" className="block text-sm font-medium text-gray-700"></label>
          <input
            type="text"
            id="firstName"
            name="firstName"
            required
            className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8"
            placeholder="First Name"
            value={firstName}
            onChange={(e) => setFirstName(e.target.value)}
          />
        </div>

        <div className="mb-2">
          <label htmlFor="lastName" className="block text-sm font-medium text-gray-700"></label>
          <input
            type="text"
            id="lastName"
            name="lastName"
            required
            className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8"
            placeholder="Last Name"
            value={lastName}
            onChange={(e) => setLastName(e.target.value)}
          />
        </div>

        <div className="mb-2">
          <label htmlFor="email" className="block text-sm font-medium text-gray-700"></label>
          <input
            type="email"
            id="email"
            name="email"
            required
            className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>

        <div className="mb-2">
          <label htmlFor="user" className="block text-sm font-medium text-gray-700"></label>
          <input
            type="text"
            id="user"
            name="user"
            required
            className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
        </div>

        <div className="mb-2">
          <label htmlFor="password" className="block text-sm font-medium text-gray-700"></label>
          <input
            type="password"
            id="password"
            name="password"
            required
            className="w-full p-3 border text-[13px] border-gray-300 rounded-md h-8"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>

        {message && <p className="text-red-500 text-sm mb-4">{message}</p>}
        <button
          type="submit"
          className="signup-btn w-full bg-red-600 text-white py-3 rounded-md h-9"
        >
          Sign Up
        </button>
      </form>
    </div>
  );
};

export default SignUpForm;