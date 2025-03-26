import React, { useState, useEffect } from 'react';
import axios from 'axios';

const typeIcons: Record<string, string> = {
  normal: '/assets/icons/normal.svg',
  fire: '/assets/icons/fire.svg',
  water: '/assets/icons/water.svg',
  electric: '/assets/icons/electric.svg',
  grass: '/assets/icons/grass.svg',
  ice: '/assets/icons/ice.svg',
  fighting: '/assets/icons/fighting.svg',
  poison: '/assets/icons/poison.svg',
  ground: '/assets/icons/ground.svg',
  flying: '/assets/icons/flying.svg',
  psychic: '/assets/icons/psychic.svg',
  bug: '/assets/icons/bug.svg',
  rock: '/assets/icons/rock.svg',
  ghost: '/assets/icons/ghost.svg',
  dragon: '/assets/icons/dragon.svg',
  dark: '/assets/icons/dark.svg',
  steel: '/assets/icons/steel.svg',
  fairy: '/assets/icons/fairy.svg',
};


const colorMap: Record<string, string> = {
  red: '#FF0000',
  blue: '#0000FF',
  green: '#00FF00',
  yellow: '#FFFF00',
  purple: '#800080',
  pink: '#FFC0CB',
  brown: '#A52A2A',
  black: '#000000',
  white: '#FFFFFF',
  gray: '#808080',
};

const isValidType = (type: string): type is keyof typeof typeIcons => {
  return type.toLowerCase() in typeIcons;
};

const Search = () => {
  interface Pokemon {
    name: string;
    pokedexNumber: number;
    color: string;
    types: string[];
    image: string;
  }

  const [pokemonList, setPokemonList] = useState<Pokemon[]>([]);
  const [filteredPokemon, setFilteredPokemon] = useState<Pokemon[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(false);

  const apiURL =
    import.meta.env.NODE_ENV === 'development'
      ? 'http://localhost:5001'
      : 'http://pokeverse.space:5001';

  useEffect(() => {
    const fetchPokemon = async () => {
      if (!searchQuery) {
        setPokemonList([]);
        setFilteredPokemon([]);
        return;
      }

      try {
        setLoading(true);
        console.log('Sending request for:', searchQuery);

        const isNumberSearch = /^\d+$/.test(searchQuery);
        let response;

        if (isNumberSearch) {
          response = await axios.get(`${apiURL}/pokemon/number/${searchQuery}`);
        } else {
          response = await axios.get(`${apiURL}/pokemon/search/${searchQuery}`);
        }

        console.log('Fetched Pokémon:', response.data);

        if (response.data && (Array.isArray(response.data) || response.data.name)) {
          const pokemonData = Array.isArray(response.data) ? response.data : [response.data];
          const pokemonListWithImages = pokemonData.map((pokemon: any) => ({
            ...pokemon,
            image: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.pokedexNumber}.png`,
            // Ensure types are lowercase for icon matching
            types: pokemon.types.map((t: string) => t.toLowerCase())
          }));

          setPokemonList(pokemonListWithImages);
          setFilteredPokemon(pokemonListWithImages);
        } else {
          console.error('Unexpected response format:', response);
          setPokemonList([]);
          setFilteredPokemon([]);
        }
      } catch (error: any) {
        console.error('Error fetching Pokémon:', error.response || error.message);
        setPokemonList([]);
        setFilteredPokemon([]);
      } finally {
        setLoading(false);
      }
    };

    const debounceTimer = setTimeout(fetchPokemon, 300);
    return () => clearTimeout(debounceTimer);
  }, [searchQuery, apiURL]);

  useEffect(() => {
    const filtered = pokemonList.filter(pokemon =>
      pokemon.name.toLowerCase().includes(searchQuery.toLowerCase())
    );
    setFilteredPokemon(filtered);
  }, [searchQuery, pokemonList]);

  // Component to render type icons with fallback
  const TypeIcon = ({ type }: { type: string }) => {
    const [imgError, setImgError] = useState(false);
    const normalizedType = type.toLowerCase();

    if (imgError || !isValidType(normalizedType)) {
      return (
        <span className="text-xs font-medium px-2 py-1 rounded-full bg-gray-100 capitalize">
          {type}
        </span>
      );
    }

    return (
      <img
        src={typeIcons[normalizedType]}
        alt={type}
        title={type}
        className="w-6 h-5 mt-1 ml-3  object-contain"
        onError={() => setImgError(true)}
      />
    );
  };

  return (
    <div className="p-4 ml-5">
      <div className="flex items-center space-x-2 mb-4">
        <img src="/assets/search.svg" alt="Dashboard" className="w-5 h-7" />
        <input
          type="text"
          placeholder="Search Pokémon..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full p-2 border border-gray-300 rounded bg-white z-10"
        />
      </div>

      {loading && (
        <div className="flex justify-center my-8">
          <div className="animate-spin rounded-full ml-10 h-12 w-12 border-t-2 border-b-2 border-blue-300"></div>
        </div>
      )}

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        {filteredPokemon.map((pokemon) => (
         <div
         key={pokemon.pokedexNumber}
         className="p-4 rounded-lg text-black shadow-lg relative hover:scale-105 transition-transform"
         style={{
          backgroundColor: pokemon.color ? `${colorMap[pokemon.color.toLowerCase()] || '#f0f0f0'}40` : '#f0f0f0',
          border: '2px dashed gray', // Set border to gray
         }}
       >

        {/* Plus button in top right corner */}
            <button
              //onClick={() => addTeam(pokemon)}
              className="absolute top-2 right-2 outline-none !bg-transparent rounded-full shadow-md z-20">
              <img 
                src="/assets/plus.svg" 
                alt="Plus" 
                className="w-3 h-3"
              />
              
            </button>

            {/* Pokéball background */}
            <div className="absolute inset-0 flex justify-center items-center opacity-10">
              <img 
                src="/assets/pokeball.svg" 
                alt="Pokéball" 
                className="w-80 h-32"
              />
            </div>
          
            {/* Pokémon image */}
            <div className="relative z-10">
              <img
                src={pokemon.image}
                alt={pokemon.name}
                className="w-24 h-24 mx-auto mb-2"
                onError={(e) => {
                  (e.target as HTMLImageElement).src = '/assets/pokemon-placeholder.png';
                }}
              />
            </div>
          
            <h3 className="text-lg font-bold capitalize relative z-10 text-center">
              {pokemon.name}
            </h3>
            
            {/* Number with background stripe */}
            <div className="relative w-full h-5 my-2">
              <div
                className="absolute top-0 left-1/2 -translate-x-1/2 w-2/3 h-full rounded-full"
                style={{ backgroundColor: pokemon.color, opacity: 0.5 }}
              />
              <p className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-sm font-bold z-10">
                #{pokemon.pokedexNumber}
              </p>
            </div>
            
            {/* Types with icons */}
            <div className={`mt-2 relative z-10 flex ${pokemon.types.length === 1 ? 'justify-center' : 'justify-center gap-2'}`}>
            <div
              className="absolute inset-0 flex  justify-center items-center rounded-full"
              style={{
                backgroundColor:'gray',
                opacity: 0.4, 
                zIndex: -1,
                padding: '14px', 
              }}
            > </div>
            {pokemon.types.map((type, idx) => (
              <TypeIcon key={idx} type={type} />
            ))}
          </div>

          </div>
        ))}
      </div>
    </div>
  );
};

export default Search;
