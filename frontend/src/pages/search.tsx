import Navbar from "../components/nav.tsx"; 
import Search from "../components/Search.tsx"; 
import { SideNav, SidebarItem } from "../components/sideNav.tsx";
import { useNavigate } from 'react-router-dom';
import './HomePage.css'; 

const LoggedIn = () => {
  const navigate = useNavigate();

  return (

    <div className="hero-class flex flex-col min-h-screen w-screen bg-white">
      {/* top nav */}
      <Navbar/>

      {/* sideNav and content container */}
      <div className="flex flex-1">
        {/* Left Sidebar */}
        <SideNav>
        
          <SidebarItem 
            icon={<img src="/assets/teams.png" alt="Teams" className="w-6 h-4" />}
            text="Teams" 
            active
            onClick={() => navigate('/teams')} 
          />

        <SidebarItem
            icon={<img src="/assets/search.svg" alt="Dashboard" className="w-5 h-5" />}
            text="Search"
            onClick={() => navigate('/search')} 
            active
          /> 
        </SideNav>

        {/* Right content */}
        <div className="top-23 fixed ml-20 right-40 left-0 h-[85vh] w-full sm:w-auto rounded bg-white shadow-sm overflow-y-auto">
          <div className="p-4  bg-white shadow-sm  w-full rounded">
            <h1 className= "ml-20 flex text-sm w-full font-bold mb-4">Search & Add To Your Team!</h1>
            <Search />
            {/* Your page content goes here */}
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoggedIn;