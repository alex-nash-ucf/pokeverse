import Navbar from "../components/nav.tsx"; 
import { SideNav, SidebarItem } from "../components/sideNav.tsx";
import { useNavigate } from 'react-router-dom';
import './HomePage.css'; 


const Teams = () => {
  const navigate = useNavigate();
  return (
    <div className="hero-class flex flex-col min-h-screen w-screen bg-white overflow-hidden">
      {/* top nav  */}
      <Navbar />

      {/* sideNav*/}
      <div className="flex flex-1">
        <SideNav>
        <SidebarItem
            icon={<img src="/assets/home.svg" alt="Dashboard" className="w-5 h-5" />}
            text="Dashboard"
            onClick={() => navigate('/loggedIn')} 
            active
          /> 
          <SidebarItem 
            icon={<img src="/assets/teams.png" alt="Teams" className="w-6 h-4" />}
            text="Teams" active 
            onClick={() => navigate('/teams')} 

          />
        
        </SideNav>

        {/* right content */}
        <div className="flex-1 p-4">
          {/* Page content goes here */}
          <h1>Teams</h1>
        </div>
      </div>
    </div>
  );
};

export default Teams;
