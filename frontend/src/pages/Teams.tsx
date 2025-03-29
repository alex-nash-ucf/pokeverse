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
  const [showModal, setShowModal] = useState(false);
  const [teamToDelete, setTeamToDelete] = useState<{ id: string | null, name: string | null }>({ id: null, name: null });
  const [popoverPosition, setPopoverPosition] = useState<{ top: number; left: number }>({ top: 0, left: 0 });
  var apiURL="";

  if (import.meta.env.NODE_ENV === 'development') {
    apiURL="http://localhost:5001";
  }
  else apiURL="http://pokeverse.space:5001";

  useEffect(() => {
    const fetchTeams = async () => {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          navigate('/login');
          return;
        }

        const response = await fetch(`${apiURL}/getTeams`, {
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
        setError('Error fetching teams');
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
      const response = await fetch(`${apiURL}/addTeams`, {
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
      setError('Error creating team');
    }
  };

  const handleDeleteTeam = (teamId: string, teamName: string, event: React.MouseEvent) => {
    setTeamToDelete({ id: teamId, name: teamName });
    const { top, left } = (event.target as HTMLElement).getBoundingClientRect();
    setPopoverPosition({ top: top + 20, left: left - 80 }); // Adjust positioning as needed
    setShowModal(true);
  };
  
  const handleConfirmDelete = async () => {
    if (!teamToDelete.id) return;

    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`${apiURL}/deleteTeam/${teamToDelete.id}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (!response.ok) {
        throw new Error('Failed to delete team');
      }

      setTeams(teams.filter(team => team._id !== teamToDelete.id));
      setShowModal(false); // Close the modal after successful deletion
      setTeamToDelete({ id: null, name: null }); // Reset the team to delete
    } catch (err) {
      setError('Error deleting team');
      setShowModal(false); // Close the modal in case of an error
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
              icon={<img src="/assets/search.svg" alt="Search" className="w-5 h-5" />}
              text="Search"
              onClick={() => navigate('/search')} 
              active
            /> 
          </SideNav>
          <div className="flex-1 p-4">
            <p className= "!text-black">Loading teams...</p>
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
            icon={<img src="/assets/search.svg" alt="Search" className="w-5 h-5" />}
            text="Search"
            onClick={() => navigate('/search')} 
            active
          /> 
        </SideNav>

        <div className="flex-1 mt-10 p-4">
          <h1 className="text-2xl font-bold !text-black mb-2">Your Teams</h1>
                    
          {teams.length === 0 ? (
            <div className="text-center py-8">
              <p className="mb-4 !text-black">You don't have any teams yet.</p>
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
                <button 
                  onClick={() => setShowCreateForm(true)}
                  className="!bg-blue-400 hover:bg-blue-600 text-white px-4 py-2 rounded"
                >
                  Create New Team
                </button>
              </div>

              <div className="flex justify-between items-center mb-4">
                <h2 className="text-xl font-semibold !text-black">Your Teams ({teams.length})</h2>
              </div>

              {showCreateForm && (
                <div className="mb-6 p-4 bg-gray-100 rounded">
                  <h3 className="font-medium mb-2 !text-black">Create A New Team</h3>
                  <input
                    type="text"
                    value={newTeamName}
                    onChange={(e) => setNewTeamName(e.target.value)}
                    placeholder="Enter team name"
                    className="w-full !text-black p-2 !border rounded mb-2"
                  />
                  <div className="flex gap-2">
                    <button 
                      onClick={handleCreateTeam}
                      className="!bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded"
                    >
                      Create
                    </button>
                    <button 
                      onClick={() => {
                        setShowCreateForm(false);
                        setNewTeamName('');
                      }}
                      className="!bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded"
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
                      <h3 className="text-lg !text-black font-medium">{team.name}</h3>
                    </div>
                    <p className="text-gray-600 mb-3">
                      {team.pokemon.length} Pokémon
                    </p>
                    <div className="flex justify-between items-center">
                      <button 
                        onClick={() => navigate(`/team/${team._id}`, { state: { teamName: team.name } })}
                        className="!bg-gray-100 text-blue-500 w-full "
                      >
                        View
                      </button>

                      <button 
                        onClick={() => navigate('/search')}
                        className="ml-4 !bg-gray-100 text-green-500 w-full "
                      >
                        Add
                      </button>
                      
                      <button 
                        onClick={(e) => handleDeleteTeam(team._id, team.name, e)}
                        className="text-red-500 !bg-gray-100 hover:text-red-700 ml-4"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Popover Modal */}
      {showModal && (
        <div 
          className="fixed !bg-transparent bg-opacity-50 inset-0 z-10"
          style={{
            top: `${popoverPosition.top}px`,
            left: `${popoverPosition.left}px`,
          }}
        >
          <div className="absolute bg-white p-4 rounded-lg shadow-lg max-w-xs w-full">
            <h2 className="text-md font-semibold !text-black mb-4">Are you sure you want to delete {teamToDelete.name}?</h2>
            <div className="flex ml-10 justify-center mt-4">
              <button 
                onClick={handleConfirmDelete} 
                className="!bg-red-500 hover:bg-red-600 text-white px-2 py-2 rounded"
              >
                Confirm
              </button>
              <button 
                onClick={() => setShowModal(false)} 
                className="ml-3 !bg-gray-300 hover:bg-gray-400 text-black px-2 py-2 rounded"
              >
                Cancel
              </button>
            </div>
          </div>
          <div>
            {error && <p>{error}</p>}
            {/* Other component code */}
          </div>
        </div>
      )}
    </div>
  );
};

export default Teams;
