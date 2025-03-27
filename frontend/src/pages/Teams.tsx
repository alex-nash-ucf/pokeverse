import { useState, useEffect } from 'react';
import Navbar from "../components/nav.tsx"; 
import { SideNav, SidebarItem } from "../components/sideNav.tsx";
import { useNavigate } from 'react-router-dom';
import './HomePage.css'; 

interface Team {
  _id: string;
  name: string;
  pokemon: any[]; // You can define a more specific Pokemon interface if needed
}

const Teams = () => {
  const navigate = useNavigate();
  const [teams, setTeams] = useState<Team[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [newTeamName, setNewTeamName] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);

  useEffect(() => {
    const fetchTeams = async () => {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          navigate('/login');
          return;
        }

        const response = await fetch('http://localhost:5001/getTeams', {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });

        if (!response.ok) {
          throw new Error('Failed to fetch teams');
        }

        const data = await response.json();
        setTeams(data);
      } catch (err) {
        setError(error);
      } finally {
        setLoading(false);
      }
    };

    fetchTeams();
  }, [navigate]);

  const handleCreateTeam = async () => {
    if (!newTeamName.trim()) {
      setError('Team name cannot be empty');
      return;
    }

    try {
      const token = localStorage.getItem('token');
      const response = await fetch('http://localhost:5001/addTeam', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ teamName: newTeamName })
      });

      if (!response.ok) {
        throw new Error('Failed to create team');
      }

      const newTeam = await response.json();
      setTeams([...teams, newTeam.team]);
      setNewTeamName('');
      setShowCreateForm(false);
      setError('');
    } catch (err) {
      setError(error);
    }
  };

  const handleDeleteTeam = async (teamId: string) => {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`http://localhost:5001/deleteTeam/${teamId}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (!response.ok) {
        throw new Error('Failed to delete team');
      }

      setTeams(teams.filter(team => team._id !== teamId));
    } catch (err) {
      setError(error);
    }
  };

  if (loading) {
    return (
      <div className="hero-class flex flex-col min-h-screen w-screen bg-white overflow-hidden">
        <Navbar />
        <div className="flex flex-1">
          <SideNav>
            <SidebarItem 
              icon={<img src="/assets/teams.png" alt="Teams" className="w-6 h-4" />}
              text="Teams" active 
              onClick={() => navigate('/teams')} 
            />
            <SidebarItem
              icon={<img src="/assets/search.svg" alt="Dashboard" className="w-5 h-5" />}
              text="Dashboard"
              onClick={() => navigate('/search')} 
              active
            /> 
          </SideNav>
          <div className="flex-1 p-4">
            <p>Loading teams...</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="hero-class flex flex-col min-h-screen w-screen bg-white overflow-hidden">
      <Navbar />
      <div className="flex flex-1">
        <SideNav>
          <SidebarItem 
            icon={<img src="/assets/teams.png" alt="Teams" className="w-6 h-4" />}
            text="Teams" active 
            onClick={() => navigate('/teams')} 
          />
          <SidebarItem
            icon={<img src="/assets/search.svg" alt="Dashboard" className="w-5 h-5" />}
            text="Dashboard"
            onClick={() => navigate('/search')} 
            active
          /> 
        </SideNav>

        <div className="flex-1 p-4">
          <h1 className="text-2xl font-bold mb-2">Your Teams</h1>
                    
          {teams.length === 0 ? (
            <div className="text-center py-8">
              <p className="mb-4">You don't have any teams yet.</p>
              <button 
                onClick={() => navigate('/search')}
                className="!bg-blue-300 hover:bg-blue-600 text-white px-4 mb-2 py-2 rounded"
              >
                Create A Team
              </button>
            </div>
          ) : (
            <div>
              <div className="flex justify-between items-center mb-4">
                <h2 className="text-xl font-semibold">Your Teams ({teams.length})</h2>
                <button 
                  onClick={() => setShowCreateForm(true)}
                  className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded"
                >
                  Create New Team
                </button>
              </div>

              {showCreateForm && (
                <div className="mb-6 p-4 bg-gray-100 rounded">
                  <h3 className="font-medium mb-2">Create New Team</h3>
                  <input
                    type="text"
                    value={newTeamName}
                    onChange={(e) => setNewTeamName(e.target.value)}
                    placeholder="Enter team name"
                    className="w-full p-2 border rounded mb-2"
                  />
                  <div className="flex gap-2">
                    <button 
                      onClick={handleCreateTeam}
                      className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded"
                    >
                      Create
                    </button>
                    <button 
                      onClick={() => {
                        setShowCreateForm(false);
                        setNewTeamName('');
                      }}
                      className="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded"
                    >
                      Cancel
                    </button>
                  </div>
                </div>
              )}

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {teams.map(team => (
                  <div key={team._id} className="border rounded-lg p-4 shadow-sm">
                    <div className="flex justify-between items-start mb-2">
                      <h3 className="text-lg font-medium">{team.name}</h3>
                      <button 
                        onClick={() => handleDeleteTeam(team._id)}
                        className="text-red-500 hover:text-red-700"
                      >
                        Delete
                      </button>
                    </div>
                    <p className="text-gray-600 mb-3">
                      {team.pokemon.length} Pokémon
                    </p>
                    <button 
                      onClick={() => navigate(`/team/${team._id}`)}
                      className="text-blue-500 hover:text-blue-700"
                    >
                      View Team
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Teams;