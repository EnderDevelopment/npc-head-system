CREATE TABLE IF NOT EXISTS npc_head_system (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    npc_id INT NOT NULL,
    attack_count INT DEFAULT 0,
    last_attack TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO npc_head_system (player_id, npc_id, attack_count) VALUES (1, 1, 0);