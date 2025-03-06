import { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import "./menu.css";

const menuItems = [
  { name: "Home", path: "/" },
  { name: "Sign Up", path: "/signup" },
  { name: "Login", path: "/login" },
  { name: "About", path: "/about" },
];

export default function Menu() {
  const navigate = useNavigate();
  const location = useLocation();
  const [selectedIndex, setSelectedIndex] = useState(0);

  useEffect(() => {
    const currentIndex = menuItems.findIndex((item) => item.path === location.pathname);
    if (currentIndex !== -1) {
      setSelectedIndex(currentIndex);
    }
  }, [location.pathname]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      event.preventDefault();

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

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [navigate, selectedIndex]);

  return (
    <div className="flex items-center gap-8">
      {/* Menu Box */}
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

      {/* controls and buttons 
      <div className="control-buttons">
        <button className="blue-circle ml-2 ">B</button>
        <button className="red-button ml-25">Red</button>
        <button className="yellow-button">Yellow </button>

        <div className="green-box rounded-lg ml-25"></div>

      </div>

      */}

      {/* controls up down l r*/}
      <div className="flex flex-col items-center gap-2">
        {/*top*/}
        <button
          className="!bg-black  p-4 h-9 rounded-t-lg hover:bg-gray-300 transition duration-200 border-b-2 border-gray-400"
          onClick={() => setSelectedIndex((prev) => (prev - 1 + menuItems.length) % menuItems.length)}>
        </button>
        {/*left */}
        <div className="flex gap-2">
          <button
            className="!bg-black p-4 h-9 rounded-l-lg hover:bg-gray-300 transition duration-200 border-r-2 border-gray-400"
            onClick={() => setSelectedIndex((prev) => (prev - 1 + menuItems.length) % menuItems.length)}>
          </button>
          {/*middle*/}
          <button
            className="!bg-black p-4 h-9 hover:bg-gray-300 transition duration-200"
            onClick={() => navigate(menuItems[selectedIndex].path)}>
          </button>
          {/*right */}
          <button
            className="!bg-black   h-9 p-4 rounded-r-lg hover:bg-gray-300 transition duration-200 border-l-2 border-gray-400"
            onClick={() => setSelectedIndex((prev) => (prev + 1) % menuItems.length)}>
          </button>
        </div>
        {/* bottom*/}
        <button
          className="!bg-black h-9 p-4 rounded-b-lg hover:bg-gray-300 transition duration-200 border-t-2 border-gray-400"
          onClick={() => setSelectedIndex((prev) => (prev + 1) % menuItems.length)}>
          </button>
      </div>
    </div>
  );
}