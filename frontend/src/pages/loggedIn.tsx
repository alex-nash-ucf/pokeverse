import Navbar from "../components/nav.tsx"; 
import Search from "../components/Search.tsx"; 
import { SideNav, SidebarItem } from "../components/sideNav.tsx";
import { useNavigate } from 'react-router-dom';
import './HomePage.css'; 

const LoggedIn = () => {
  const navigate = useNavigate();

  return (
    <div className="hero-class flex flex-col min-h-screen w-screen bg-white overflow-hidden">
      {/* top nav */}
      <Navbar />

      {/* sideNav and content container */}
      <div className="flex flex-1">
        {/* Left Sidebar */}
        <SideNav>
          <SidebarItem
            icon={<img src="/assets/home.svg" alt="Dashboard" className="w-5 h-5" />}
            text="Dashboard"
            onClick={() => navigate('/loggedIn')} 
            active
          /> 
          <SidebarItem 
            icon={<img src="/assets/teams.png" alt="Teams" className="w-6 h-4" />}
            text="Teams" 
            active
            onClick={() => navigate('/teams')} 
          />
          <SidebarItem 
            icon={<img src="/assets/heart.svg" alt="Favs" className="w-6 h-4.5" />}
            text="Favorites" 
            onClick={() => navigate('/favs')} 
            active
          />
          <SidebarItem 
            icon={<img src="/assets/community.svg" alt="Community" className="w-6 h-6" />}
            text="Community" 
            onClick={() => navigate('/community')} 
            active
          />
        </SideNav>

        {/* Right content */}
        <div className="top-23 right-40 left-0 h-[85vh] w-full sm:w-auto rounded bg-white shadow-sm overflow-y-auto">
          <div className="p-4 bg-white shadow-sm rounded">
            <h1 className="ml-25 flex text-2xl font-bold mb-4">Search, Build, and Share!</h1>
            <Search />
            {/* Your page content goes here */}
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoggedIn;