import { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { trackMetric } from "../services/metrics"; // ✅ Import trackMetric
import { auth } from "../firebase/firebaseConfig";
import { 
  User, 
  onAuthStateChanged, 
  signInWithEmailAndPassword, 
  createUserWithEmailAndPassword, 
  signOut,
  updateProfile // ✅ Import updateProfile
} from "firebase/auth";
import toast from "react-hot-toast"
// Define types for TypeScript
interface AuthContextType {
  user: User | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  signup: (email: string, password: string, name: string) => Promise<User>; // ✅ Return User
  logout: () => Promise<void>;
}

// Create Auth Context
const AuthContext = createContext<AuthContextType | undefined>(undefined);

// AuthProvider Component
export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  // Function to log in
 const login = async (email: string, password: string) => {
  try {
    await signInWithEmailAndPassword(auth, email, password);
    trackMetric("login"); 
  } catch (error) {
    trackMetric("auth-error"); 
    throw error;
  }
};

  // Function to sign up
  const signup = async (email: string, password: string, name: string): Promise<User> => {
  try {
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;

    await updateProfile(user, { displayName: name });
    setUser({ ...user, displayName: name });

    trackMetric("signup");
    return user;
  } catch (error) {
    trackMetric("auth-error");
    throw error;
  }
};

// ✅ Global Logout with Toast
  const logout = async () => {
    try {
      await signOut(auth);
      toast.success("Logout successful! 🎉"); // ✅ Toast persists globally
    } catch (error: any) {
      console.error("Logout Error:", error);
      toast.error(error.message || "Logout failed! ❌");
    }
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, signup, logout }}>
      {!loading && children}
    </AuthContext.Provider>
  );
};

// Custom hook for using Auth Context
export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};
