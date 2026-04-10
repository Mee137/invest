-- حذف القاعدة إذا كانت موجودة (اختياري)
-- DROP DATABASE IF EXISTS invest_db;

CREATE DATABASE IF NOT EXISTS invest_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;

USE invest_db;

-- Table: Users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('investor', 'startup_founder', 'business_owner', 'admin') DEFAULT 'investor',
    phone VARCHAR(20),
    location VARCHAR(100),
    profile_picture TEXT,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Startups
CREATE TABLE startups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    founder_id INT,
    category VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    short_description TEXT,
    logo TEXT,
    cover_image TEXT,
    location VARCHAR(100),
    stage VARCHAR(50),
    funding_goal DECIMAL(15,2) NOT NULL,
    funding_raised DECIMAL(15,2) DEFAULT 0,
    currency VARCHAR(10) DEFAULT 'DZD',
    status ENUM('pending', 'approved', 'funded', 'closed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (founder_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Table: Investments
CREATE TABLE investments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    startup_id INT,
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'DZD',
    investment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (startup_id) REFERENCES startups(id) ON DELETE CASCADE
);

-- Table: Payments
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2) NOT NULL,
    payment_method VARCHAR(50),
    status ENUM('pending', 'confirmed', 'failed') DEFAULT 'pending',
    confirmation_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table: Properties (for Dary Real Estate)
CREATE TABLE properties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startup_id INT,
    title VARCHAR(255),
    price DECIMAL(15,2),
    location VARCHAR(255),
    type VARCHAR(50),
    image TEXT,
    virtual_tour_link TEXT,
    FOREIGN KEY (startup_id) REFERENCES startups(id) ON DELETE CASCADE
);

SELECT '✅ Database "invest_db" created successfully!' AS Message;

USE invest_db;

SHOW TABLES;
SELECT  * from startups;