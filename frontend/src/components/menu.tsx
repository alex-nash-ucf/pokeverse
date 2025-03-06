import { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom"; 
import './menu.css'; 

const menuItems = [
  { name: "Home", path: "/" },
  { name: "Sign Up", path: "/signup" },
  { name: "Login", path: "/login" },
  { name: "About", path: "/about" }
];

export default function Menu(){
  const navigate = useNavigate();
  const location = useLocation();
  const [selectedIndex, setSelectedIndex] = useState(0);

  useEffect(() =>{
    const currentIndex = menuItems.findIndex(item => item.path === location.pathname);
    if (currentIndex !== -1) {
      setSelectedIndex(currentIndex);
    }
  }, [location.pathname]);

  useEffect(() =>{
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === "ArrowDown") {
        setSelectedIndex((prev) => (prev + 1) % menuItems.length);
      } else if (event.key === "ArrowUp") {
        setSelectedIndex((prev) => (prev - 1 + menuItems.length) % menuItems.length);
      } else if (event.key === "ArrowLeft") {
        setSelectedIndex((prev) => (prev - 1 + menuItems.length) % menuItems.length);
      } else if (event.key === "ArrowRight") {
        setSelectedIndex((prev) => (prev + 1) % menuItems.length);
      } else if (event.key === "Enter") {
        navigate(menuItems[selectedIndex].path);
      }
    };

    //event listener global
    window.addEventListener("keydown", handleKeyDown);

    return ()=> {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [navigate, selectedIndex]);

  return (
    <div 
      className="menu-box flex justify-center items-center outline-none focus:outline-none"
      tabIndex={0}
    >
      <div className="menu-border border-4 border-black bg-white px-6 py-4 rounded-lg shadow-md">
        {menuItems.map((item, index) => (
          <div 
            key={index} 
            className={`flex items-center px-2 py-1 cursor-pointer ${
              selectedIndex === index ? "font-bold" : ""
            }`} 
            onClick={() => navigate(item.path)}
          >
            <span className={`mr-2 ${selectedIndex === index ? "visible" : "invisible"}`}>
              <img src="/assets/arrow.svg" alt="Arrow" className="w-6 h-6" />
            </span>
            {item.name}
          </div>
        ))}
      </div>
    </div>
  );
}
