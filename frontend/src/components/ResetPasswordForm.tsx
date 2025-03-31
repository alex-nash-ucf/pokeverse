import { useState } from "react";

const ResetPasswordForm = () => {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const apiURL = import.meta.env.NODE_ENV === 'development'
      ? "http://localhost:5173"
      : "http://pokeverse.space";

    try {
      const response = await fetch(`${apiURL}/forgot-password`, {
        method: "POST",
        body: JSON.stringify({ email }),
        headers: { "Content-Type": "application/json" },
      });

      if (!response.ok) {
        setMessage("Error: Invalid response from server");
        return;
      }

      const res = await response.json();
      console.log("Reset Password response:", res);

      if (res.success) {
        setMessage("Password reset instructions have been sent to your email.");
      } else {
        setMessage("Email not found or unable to send reset instructions.");
      }

    } catch (error) {
      setMessage("Error occurred while sending reset email.");
      console.error("Reset Pass Error:", error);
    }
    
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
      {message && <p className="text-sm text-red-500">{message}</p>}
    </form>
  );
};

export default ResetPasswordForm;
