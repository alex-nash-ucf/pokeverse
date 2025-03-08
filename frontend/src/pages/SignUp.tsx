import Navbar from "../components/nav.tsx"; 
import Menu from "../components/menu.tsx"; 
import './HomePage.css'; 

const Login = () => {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-white">
      <Navbar />

      <div className="border-4 border-black p-6 rounded-lg text-center max-w-3xl w-full sm:w-[700px] md:w-[800px] lg:w-[900px] sm:h-[300px] md:h-[300px] mt-20 flex mx-4">
        {/* left side*/}
        <div className="w-1/2 flex flex-col justify-center items-start space-y-4">
          <h1 className="hero-text font-[PokemonFont] text-[20px]">
            Welcome, <br></br>Join Us Today!
          </h1>

          <p className="text-sm font-[PokemonFont] text-[12px] font-light text-gray-500 dark:text-gray-400">
          Already have an account?  
            <a href="/login" className="font-medium !underline !text-red-600 ml-2">
              <br></br>Login here
            </a>
          </p>
        </div>

        {/*right side*/}
        <div className="w-1/2 p-6 signup-box">
          <form className="bg-transparent w-8/10 ml-10 pt-2">
            <div className="mb-2">
              <label htmlFor="firstName" className="block text-sm font-medium text-gray-700 "></label>
              <input type="text" id="firstName" name="firstName" required className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8" placeholder="First Name"/>
            </div>

            <div className="mb-2">
              <label htmlFor="lastName" className="block text-sm font-medium text-gray-700 "></label>
              <input type="text" id="lastName" name="lastName" required className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8" placeholder="Last Name"/>
            </div>

            <div className="mb-2">
              <label htmlFor="email" className="block text-sm font-medium text-gray-700 "></label>
              <input type="email" id="email" name="email" required className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8" placeholder="Email"/>
            </div>

            <div className="mb-2">
              <label htmlFor="user" className="block text-sm font-medium text-gray-700 "></label>
              <input type="text" id="user" name="user" required className="w-full p-3 border border-gray-300 text-[13px] rounded-md h-8" placeholder="Username"/>
            </div>
            
            <div className="mb-2">
              <label htmlFor="password" className="block text-sm font-medium text-gray-700"></label>
              <input type="password" id="password" name="password" required className=" w-full p-3 border text-[13px] border-gray-300 rounded-md h-8" placeholder="Password"/>
            </div>

            <button 
              type="submit" 
              className="signup-btn w-full bg-red-600 text-white py-3 rounded-md h-9">
              Sign Up
            </button>

            <div className="mt-4 text-center font-[PokemonFont] text-[10px]">
             
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
