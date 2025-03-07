import Navbar from "../components/nav.tsx"; 
import Menu from "../components/menu.tsx"; 
import './HomePage.css'; 

const teamMembers = [
  { name: "Alex Nash", role: "Project Manager", img: "/assets/eevee.svg" },
  { name: "Yama Jiang", role: "Frontend - Web", img: "/assets/meow.svg" },
  { name: "Lucas Salinas", role: "Frontend - Mobile", img: "/assets/dratini.svg" },
  { name: "Nathan Davis", role: "Frontend - Mobile", img: "/assets/char.svg" },
  { name: "Angela Le", role: "API", img: "/assets/pika.svg" },
  { name: "Lance Nelson", role: "API", img: "/assets/psy.svg" },
  { name: "Denis Irala Morales", role: "Database & API", img: "/assets/bulb.svg" }
];

const About = () => {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-white">
      <Navbar />

      <div className="border-4 border-black p-6 rounded-lg text-center max-w-3xl w-full mt-20 mx-4">
        <h1 className="hero-text font-[PokemonFont] text-[20px] mb-4">Our Team!</h1>

        {/* members grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 ">
          {teamMembers.map((member, index) => (
            <div key={index} className="flex items-center bg-gray-100 p-2 rounded-lg shadow-md w-full">
              <img src={member.img} alt={member.name} className=" w-12 h-12 object-cover" />
              <div className="ml-2 flex items-center">
                <h2 className="text-xs font-bold ml-3">{member.name} &nbsp;</h2>
                <p className="text-xs text-gray-600">( {member.role} )</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="mt-4 w-full max-w-3xl mx-4">
        <Menu />
      </div>
    </div>
  );
};

export default About;
