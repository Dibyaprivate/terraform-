-- Use the target database
USE dev;

-- ----------------------------
-- Create 'users' table
-- ----------------------------
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique ID
    name VARCHAR(100) NOT NULL,                      -- User name
    email VARCHAR(100) NOT NULL UNIQUE,               -- Unique email
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- Auto timestamp
);

-- ----------------------------
-- Create 'products' table
-- ----------------------------
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Unique ID
    name VARCHAR(100) NOT NULL,                      -- Product name
    price DECIMAL(10, 2) NOT NULL,                   -- Product price
    stock INT DEFAULT 0,                             -- Default stock 0
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- Created date
);

-- ----------------------------
-- Create 'orders' table
-- ----------------------------
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,               -- Order ID
    user_id INT,                                     -- Linked user ID
    order_date DATE,                                 -- Order date
    total_amount DECIMAL(10, 2),                     -- Order total
    FOREIGN KEY (user_id) REFERENCES users(id)       -- Foreign key reference
);

-- ----------------------------
-- Fix MySQL Authentication Plugin for RDS
-- ----------------------------
ALTER USER 'admin'@'%' IDENTIFIED WITH caching_sha2_password BY 'Password123!';


-- Apply all privilege changes
FLUSH PRIVILEGES;
-- End of SQL script
