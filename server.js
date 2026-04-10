const express = require('express');
const path = require('path');
const cors = require('cors');
const sequelize = require('./config/database');
const User = require('./models/User');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// ==================== Main Pages ====================

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get('/signup', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'signup.html'));
});

app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

app.get('/profile', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'profile.html'));
});

app.get('/payment', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'payment.html'));
});

// ==================== API Routes ====================

// Signup API
app.post('/api/signup', async (req, res) => {
    console.log("📥 Signup request received:", req.body);

    try {
        const { full_name, email, password, role } = req.body;

        if (!full_name || !email || !password) {
            return res.status(400).json({ success: false, message: "All fields are required" });
        }

        const newUser = await User.create({
            full_name,
            email,
            password_hash: password,
            role: role || 'investor'
        });

        console.log("✅ User created with ID:", newUser.id);

        res.json({ 
            success: true, 
            message: "Account created successfully!" 
        });

    } catch (error) {
        console.error("❌ Signup error:", error.message);
        res.status(500).json({ 
            success: false, 
            message: "Failed to create account (email may already exist)" 
        });
    }
});

// Login API
app.post('/api/login', async (req, res) => {
    console.log("📥 Login request received:", req.body);

    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ success: false, message: "Email and password are required" });
        }

        const user = await User.findOne({ where: { email } });

        if (!user) {
            return res.status(401).json({ success: false, message: "Invalid email or password" });
        }

        if (user.password_hash === password) {
            console.log("✅ Login successful for user:", user.id);
            res.json({ 
                success: true, 
                message: "Login successful!",
                user: {
                    id: user.id,
                    full_name: user.full_name,
                    email: user.email,
                    role: user.role
                }
            });
        } else {
            res.status(401).json({ success: false, message: "Invalid email or password" });
        }

    } catch (error) {
        console.error("❌ Login error:", error.message);
        res.status(500).json({ success: false, message: "Server error" });
    }
});

// Test route
app.get('/test', (req, res) => {
    res.json({ message: "✅ Server is working!" });
});

// Start Server
const startServer = async () => {
    try {
        await sequelize.sync({ alter: true });
        console.log('✅ Database connected and synced');

        app.listen(PORT, () => {
            console.log(`\n🚀 Invest server is running on http://localhost:${PORT}`);
        });
    } catch (error) {
        console.error('❌ Database connection failed:', error);
    }
};

startServer();