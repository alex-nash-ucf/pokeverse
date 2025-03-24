import React, { useState } from 'react';
import Navbar from "../components/nav.tsx";
import './HomePage.css';

const LoggedIn = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  return (
    <div className="hero-class flex flex-col min-h-screen w-screen bg-white overflow-hidden">
      <Navbar />
      <div className="flex">
        <div className={`fixed inset-y-0 left-0 transform ${isMenuOpen ? 'translate-x-0' : '-translate-x-full'} transition-transform duration-300 ease-in-out bg-gray-800 text-white w-64`}>
          <button onClick={toggleMenu} className="p-4">
          </button>
          <ul className="mt-10">
            <li className="p-4 hover:bg-gray-700">Home</li>
            <li className="p-4 hover:bg-gray-700">Profile</li>
            <li className="p-4 hover:bg-gray-700">Settings</li>
            <li className="p-4 hover:bg-gray-700">Logout</li>
          </ul>
        </div>
        <div className="flex-1 p-4">
          <button onClick={toggleMenu} className="p-2">
          </button>
          <h1 className="mt-50">Wow, you're logged in!</h1>
          {/* Your content here */}
        </div>
      </div>
    </div>
  );
};

export default LoggedIn;