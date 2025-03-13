import { useState } from "react";

const ResetPasswordForm = () => {
  const [email, setEmail] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // add password reset logic here 

    
    console.log("Reset link sent to:", email);
  };

  return (
    <form onSubmit={handleSubmit} className="w-1/2 flex flex-col space-y-4">

    <p className="text-sm font-[PokemonFont] text-[12px] font-light text-gray-500 dark:text-gray-400">
        Enter your email below, and we'll send you a link to reset your password.
    </p>
      <label htmlFor="email" className="block text-sm font-medium text-gray-700"></label>
      <input
        type="email"
        placeholder="Enter your email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        className="border p-2 rounded border-gray-300 text-[13px] text-gray-700 w-full"
        required
      />
      <button type="submit" className="reset-btn bg-red-500 !text-[13px] !font-[PokemonFont] text-white p-4 rounded">
        Send Reset Link
      </button>
    
    </form>
  );
};

export default ResetPasswordForm;
