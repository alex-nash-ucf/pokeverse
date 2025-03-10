import Navbar from "../components/nav.tsx"; 
import Menu from "../components/menu.tsx"; 
import './HomePage.css'; 


const LoggedIn = () => {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-white">
      <Navbar />
    <h1 className= "mt-50">wow ur logged in!</h1>
    
    </div>
  );
};

export default LoggedIn;
