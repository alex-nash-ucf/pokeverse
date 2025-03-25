import React, { useState, useEffect } from 'react';
import axios from 'axios';

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
      }
    };

    fetchPokemon();
  }, [searchQuery, apiURL]);

  useEffect(() => {
    const filtered = pokemonList.filter(pokemon =>
      pokemon.name.toLowerCase().includes(searchQuery.toLowerCase())
    );
    setFilteredPokemon(filtered);
  }, [searchQuery, pokemonList]);

  return (
    <div className="p-4 ml-20">
      
      <input
        type="text"
        placeholder="Search Pokémon..."
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        className="w-full p-2 mb-4 border border-gray-300 rounded sticky top-0 bg-white z-10"
      />
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        {filteredPokemon.map((pokemon) => (
          <div
            key={pokemon.pokedexNumber}
            className="p-4 rounded-lg text-black shadow-lg"
            style={{
              backgroundColor: 'white',
              border: `2px solid ${pokemon.color}`,
            }}
          >
            <img
              src={pokemon.image}
              alt={pokemon.name}
              className="w-24 h-24 mx-auto mb-2"
            />
            <h3 className="text-lg font-bold capitalize">{pokemon.name}</h3>
            <p className="text-sm">#{pokemon.pokedexNumber}</p>
            <div className="mt-2">
              {pokemon.types.map((type) => (
                <span
                  key={type}
                  className="inline-block bg-white text-black px-2 py-1 rounded-full text-xs mr-1"
                >
                  {type}
                </span>
              ))}
            </div>

            
          </div>
        ))}
      </div>
    </div>
  );
};

export default Search;