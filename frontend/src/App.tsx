import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage.tsx";
import SignUp from "./pages/SignUp.tsx";
import Login from "./pages/Login.tsx";
import About from "./pages/About.tsx";
import Search from "./pages/search.tsx"; 
import ResetPass from "./pages/resetpass.tsx"; 
import TeamsPage from "./pages/Teams.tsx"; 
import ResetPassPage from "./pages/ResetPassPage.tsx"; 
<<<<<<< HEAD
import Verification from "./pages/Verification.tsx";
=======
import ViewTeamPage from './pages/ViewTeamPage.tsx';
>>>>>>> 005bc33ce01b8c4110665b091142db3aac332c05



import './App.css';
import { AuthProvider, ProtectedRoute } from "./components/AuthProvider.tsx";

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
          <Route path="/search" element={<ProtectedRoute> <Search/> </ProtectedRoute>}/>
          <Route path="/resetpass" element={<ResetPass/>} />
          <Route path="/teams" element={<ProtectedRoute><TeamsPage/> </ProtectedRoute>} />
          <Route path="/forgot-password" element={<ResetPassPage/>} />
<<<<<<< HEAD
          <Route path="/verification/:token" element={<Verification/>} />
=======
          <Route path="/team/:teamId" element={<ProtectedRoute><ViewTeamPage /></ProtectedRoute>} />

>>>>>>> 005bc33ce01b8c4110665b091142db3aac332c05


        </Routes>
      </div>
    </Router>
    </AuthProvider>
  );
}

export default App;
