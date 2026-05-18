-- Example chat table schema (MySQL)
-- Run this manually when you're ready; the application does not auto-create tables.
CREATE TABLE IF NOT EXISTS chat_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  sender_name VARCHAR(255),
  receiver_name VARCHAR(255),
  sender_role VARCHAR(50),
  message TEXT,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

