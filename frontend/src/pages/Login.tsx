import Navbar from "../components/nav.tsx"; 
import Menu from "../components/menu.tsx"; 
import './HomePage.css'; 
import { useState } from "react";

const Login = () => {

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-white">
      <Navbar />

      <div className="border-4 border-black p-6 rounded-lg text-center max-w-3xl w-full sm:w-[700px] md:w-[800px] lg:w-[900px] sm:h-[300px] md:h-[300px] mt-20 flex mx-4">
        {/* left side*/}
        <div className="w-1/2 flex flex-col justify-center items-start space-y-4">
          <h1 className="hero-text font-[PokemonFont] text-[20px]">
            Welcome back!
          </h1>

          <p className="text-sm font-[PokemonFont] text-[12px] font-light text-gray-500 dark:text-gray-400">
          Don’t have an account yet?  
            <a href="/signup" className="font-medium !underline !text-red-600 ml-2">
              <br></br>Sign up here
            </a>
          </p>
        </div>

        {/*right side*/}
        <div className="w-1/2 p-6 login-box">
          <form className="bg-transparent">
            <div className="mb-4">
              <label htmlFor="user" className="block text-sm font-medium text-gray-700 "></label>
              <input type="text" id="user" name="user" required className="w-full p-3 border border-gray-300 text-[13px] rounded-md" placeholder="Username" />
            </div>
            
            <div className="mb-4">
              <label htmlFor="password" className="block text-sm font-medium text-gray-700"></label>
              <input type="password" id="password" name="password" required className=" w-full p-3 border text-[13px] border-gray-300 rounded-md" placeholder="Password"/>
            </div>

            <button 
              type="submit" 
              className="login-btn w-full bg-red-600 text-white py-3 rounded-md">
              Login
            </button>

            <div className="mt-4 text-center font-[PokemonFont] text-[10px]">
              Forgot Password? 
              <a href="#" className="font-medium !text-red-600 !underline !hover:text-red-700 ml-2">
                Reset here
              </a>
            </div>

          </form>
        </div>
      </div>


      <div className="mt-4 w-full max-w-3xl mx-4 mr-13">
        <Menu />
      </div>
    </div>
  );
};

export default Login;
