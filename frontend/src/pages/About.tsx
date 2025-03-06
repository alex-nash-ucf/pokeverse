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
            Our Team!
          </h1>

        </div>

        {/*right side*/}
        <div className="w-1/2 p-6 signup-box">
          
          
        </div>
      </div>


      <div className="mt-4 w-full max-w-3xl mx-4 mr-13">
        <Menu />
      </div>
    </div>
  );
};

export default Login;
