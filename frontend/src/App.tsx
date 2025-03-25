import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage.tsx";
import SignUp from "./pages/SignUp.tsx";
import Login from "./pages/Login.tsx";
import About from "./pages/About.tsx";
import LoggedIn from "./pages/loggedIn.tsx"; 
import ResetPass from "./pages/resetpass.tsx"; 
import TeamsPage from "./pages/Teams.tsx"; 


import './App.css';
import { AuthProvider } from "./components/AuthProvider.tsx";

function App() {
  return (
    <AuthProvider>
    <Router>
      <div className="content">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/signup" element={<SignUp />} />
          <Route path="/login" element={<Login/>} />
          <Route path="/about" element={<About/>} />
          <Route path="/loggedIn" element={<LoggedIn/>} />
          <Route path="/resetpass" element={<ResetPass/>} />
          <Route path="/teams" element={<TeamsPage/>} />


        </Routes>
      </div>
    </Router>
    </AuthProvider>
  );
}

export default App;
